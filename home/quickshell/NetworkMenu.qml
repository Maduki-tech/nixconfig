pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Networking
import Quickshell.Wayland._WlrLayerShell

PanelWindow {
    id: root
    signal close()

    anchors { top: true; right: true }
    margins { top: 44 }
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    implicitWidth: 320
    implicitHeight: card.implicitHeight
    color: "transparent"

    onVisibleChanged: if (visible) focusGrab.active = true

    HyprlandFocusGrab {
        id: focusGrab
        windows: [root]
        onCleared: root.close()
    }

    // ── Device / network lookup ─────────────────────────────────
    readonly property var wifiDevice: {
        const devs = Networking.devices.values
        for (let i = 0; i < devs.length; i++) {
            if (devs[i].type === DeviceType.Wifi) return devs[i]
        }
        return null
    }

    readonly property var wiredDevice: {
        const devs = Networking.devices.values
        for (let i = 0; i < devs.length; i++) {
            if (devs[i].type === DeviceType.Wired) return devs[i]
        }
        return null
    }

    readonly property var activeWifiNetwork: {
        if (!root.wifiDevice) return null
        const nets = root.wifiDevice.networks.values
        for (let i = 0; i < nets.length; i++) {
            if (nets[i].connected) return nets[i]
        }
        return null
    }

    readonly property bool wiredConnected: root.wiredDevice?.connected ?? false
    readonly property bool wifiConnected: root.wifiDevice?.connected ?? false
    readonly property var activeDevice: root.wiredConnected ? root.wiredDevice
                                       : root.wifiConnected  ? root.wifiDevice
                                       :                        null

    readonly property string statusText: !root.wifiDevice && !root.wiredDevice ? "Unavailable"
                                        : !Networking.wifiHardwareEnabled       ? "Wi-Fi hardware off"
                                        : root.wiredConnected                  ? "Connected (wired)"
                                        : root.wifiConnected                   ? "Connected"
                                        : !Networking.wifiEnabled              ? "Wi-Fi off"
                                        :                                        "Not connected"

    function isOpen(net) {
        return net?.security === WifiSecurityType.Open
    }

    function signalBars(strength) {
        if (strength >= 75) return "▂▄▆█"
        if (strength >= 50) return "▂▄▆_"
        if (strength >= 25) return "▂▄__"
        return "▂___"
    }

    function formatRate(bytesPerSec) {
        if (bytesPerSec >= 1024 * 1024) return (bytesPerSec / (1024 * 1024)).toFixed(1) + " MB/s"
        if (bytesPerSec >= 1024) return (bytesPerSec / 1024).toFixed(1) + " KB/s"
        return Math.round(bytesPerSec) + " B/s"
    }

    // ── Live throughput (native API has no bandwidth counters) ──
    property real rxRate: 0
    property real txRate: 0
    property real _lastRx: 0
    property real _lastTx: 0
    property real _lastTs: 0
    property string _lastIface: ""

    function updateNetStat(text) {
        const iface = root.activeDevice?.name
        if (!iface) {
            root.rxRate = 0
            root.txRate = 0
            root._lastIface = ""
            return
        }
        const now = Date.now()
        const lines = text.split("\n")
        for (let i = 0; i < lines.length; i++) {
            const line = lines[i]
            const idx = line.indexOf(":")
            if (idx < 0) continue
            const name = line.slice(0, idx).trim()
            if (name !== iface) continue

            const fields = line.slice(idx + 1).trim().split(/\s+/)
            const rx = parseInt(fields[0])
            const tx = parseInt(fields[8])

            if (root._lastIface === iface && root._lastTs > 0) {
                const dt = (now - root._lastTs) / 1000
                if (dt > 0) {
                    root.rxRate = Math.max(0, (rx - root._lastRx) / dt)
                    root.txRate = Math.max(0, (tx - root._lastTx) / dt)
                }
            } else {
                root.rxRate = 0
                root.txRate = 0
            }

            root._lastRx = rx
            root._lastTx = tx
            root._lastTs = now
            root._lastIface = iface
            return
        }
        root.rxRate = 0
        root.txRate = 0
    }

    Process {
        id: netstatProc
        command: ["sh", "-c", "cat /proc/net/dev"]
        running: false
        stdout: StdioCollector {
            id: netstatCollector
            onStreamFinished: root.updateNetStat(netstatCollector.text)
        }
    }

    Timer {
        interval: 1500
        repeat: true
        triggeredOnStart: true
        running: root.visible && root.activeDevice !== null
        onTriggered: if (!netstatProc.running) netstatProc.running = true
    }

    // ── Password prompt state ────────────────────────────────────
    property var pendingNetwork: null

    Rectangle {
        id: card
        anchors { top: parent.top; left: parent.left; right: parent.right }
        implicitHeight: col.implicitHeight + 24
        radius: 12
        color: "#11111b"
        border.color: "#33ccff"
        border.width: 1

        ColumnLayout {
            id: col
            anchors { top: parent.top; left: parent.left; right: parent.right; margins: 14 }
            spacing: 10

            // ── Header ──────────────────────────────────────────────
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: "Network"
                    color: "#cdd6f4"
                    font.pixelSize: 14
                    font.bold: true
                }

                Text {
                    text: root.statusText
                    color: "#6c7086"
                    font.pixelSize: 11
                }

                Item { Layout.fillWidth: true }

                Rectangle {
                    width: 22; height: 22; radius: 11
                    color: closeMa.containsMouse ? "#313244" : "transparent"
                    Behavior on color { ColorAnimation { duration: 80 } }
                    Text { anchors.centerIn: parent; text: "✕"; color: "#6c7086"; font.pixelSize: 11 }
                    MouseArea { id: closeMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: root.close() }
                }

                // Wi-Fi power toggle
                Rectangle {
                    width: 42; height: 22; radius: 11
                    color: Networking.wifiEnabled ? "#33ccff" : "#313244"
                    Behavior on color { ColorAnimation { duration: 150 } }
                    opacity: (root.wifiDevice && Networking.wifiHardwareEnabled) ? 1 : 0.4

                    Rectangle {
                        width: 18; height: 18; radius: 9
                        anchors.verticalCenter: parent.verticalCenter
                        x: Networking.wifiEnabled ? parent.width - width - 2 : 2
                        color: "#cdd6f4"
                        Behavior on x { NumberAnimation { duration: 150; easing.type: Easing.InOutQuad } }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        enabled: root.wifiDevice !== null && Networking.wifiHardwareEnabled
                        onClicked: Networking.wifiEnabled = !Networking.wifiEnabled
                    }
                }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: "#313244" }

            // ── Ethernet status ──────────────────────────────────────
            RowLayout {
                Layout.fillWidth: true
                visible: root.wiredDevice !== null
                spacing: 8

                Text { text: "⬡"; color: root.wiredConnected ? "#00ff99" : "#6c7086"; font.pixelSize: 14 }

                Column {
                    Layout.fillWidth: true
                    spacing: 1
                    Text { text: "Ethernet"; color: "#cdd6f4"; font.pixelSize: 12 }
                    Text {
                        text: root.wiredConnected ? (root.wiredDevice.network?.name ?? root.wiredDevice.name) : "Not connected"
                        color: "#6c7086"
                        font.pixelSize: 10
                    }
                }

                Item { Layout.fillWidth: true }

                Rectangle {
                    width: wiredActionLabel.implicitWidth + 16
                    height: 24
                    radius: 6
                    visible: root.wiredConnected
                    color: wiredMa.containsMouse ? "#313244" : "#1a1a2e"
                    border.color: "#f38ba8"
                    border.width: 1
                    Behavior on color { ColorAnimation { duration: 80 } }

                    Text {
                        id: wiredActionLabel
                        anchors.centerIn: parent
                        text: "Disconnect"
                        color: "#f38ba8"
                        font.pixelSize: 10
                    }

                    MouseArea {
                        id: wiredMa
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.wiredDevice.network?.disconnect()
                    }
                }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: "#313244"; visible: root.wiredDevice !== null }

            // ── Usage + signal ───────────────────────────────────────
            RowLayout {
                Layout.fillWidth: true
                visible: root.activeDevice !== null
                spacing: 14

                Column {
                    spacing: 1
                    Text { text: "↓ " + root.formatRate(root.rxRate); color: "#00ff99"; font.pixelSize: 11 }
                    Text { text: "↑ " + root.formatRate(root.txRate); color: "#f9e2af"; font.pixelSize: 11 }
                }

                Item { Layout.fillWidth: true }

                Row {
                    spacing: 4
                    visible: root.wifiConnected
                    Text {
                        text: root.signalBars(root.activeWifiNetwork?.signalStrength ?? 0)
                        color: "#33ccff"
                        font.pixelSize: 12
                    }
                    Text {
                        text: Math.round(root.activeWifiNetwork?.signalStrength ?? 0) + "%"
                        color: "#6c7086"
                        font.pixelSize: 11
                    }
                }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: "#313244"; visible: root.activeDevice !== null }

            // ── Scan button ───────────────────────────────────────────
            Rectangle {
                Layout.fillWidth: true
                height: 34
                radius: 8
                visible: root.wifiDevice !== null && Networking.wifiEnabled
                color: scanMa.containsMouse
                       ? (root.wifiDevice?.scannerEnabled ? "#1a3a28" : "#1e2a3a")
                       : (root.wifiDevice?.scannerEnabled ? "#152d20" : "#1e1e2e")
                border.color: root.wifiDevice?.scannerEnabled ? "#00ff99" : "#313244"
                border.width: 1
                Behavior on color { ColorAnimation { duration: 80 } }

                Text {
                    anchors.centerIn: parent
                    text: root.wifiDevice?.scannerEnabled ? "⬤  Scanning for networks..." : "⊕  Scan for networks"
                    color: root.wifiDevice?.scannerEnabled ? "#00ff99" : "#a6adc8"
                    font.pixelSize: 12
                }

                MouseArea {
                    id: scanMa
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: if (root.wifiDevice) root.wifiDevice.scannerEnabled = !root.wifiDevice.scannerEnabled
                }
            }

            // ── Disabled / unavailable messages ─────────────────────
            Text {
                Layout.fillWidth: true
                Layout.bottomMargin: 4
                text: !root.wifiDevice && !root.wiredDevice ? "No network device found."
                    : !root.wifiDevice ? ""
                    : !Networking.wifiHardwareEnabled ? "Wi-Fi is disabled by a hardware switch."
                    : !Networking.wifiEnabled ? "Enable Wi-Fi to see nearby networks."
                    : ""
                visible: text !== ""
                color: "#6c7086"
                font.pixelSize: 12
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }

            // ── Wi-Fi network list ────────────────────────────────────
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4
                visible: root.wifiDevice !== null && Networking.wifiEnabled

                Repeater {
                    model: root.wifiDevice?.networks ?? null

                    delegate: ColumnLayout {
                        id: netRow
                        required property WifiNetwork modelData

                        Layout.fillWidth: true
                        spacing: 0

                        Rectangle {
                            Layout.fillWidth: true
                            height: 52
                            radius: 8
                            color: "#1e1e2e"

                            RowLayout {
                                anchors { fill: parent; leftMargin: 10; rightMargin: 10 }
                                spacing: 10

                                Column {
                                    spacing: 1
                                    Text {
                                        text: root.signalBars(netRow.modelData.signalStrength)
                                        color: "#33ccff"
                                        font.pixelSize: 12
                                    }
                                    Text {
                                        text: root.isOpen(netRow.modelData) ? "" : "🔒"
                                        font.pixelSize: 9
                                    }
                                }

                                Column {
                                    Layout.fillWidth: true
                                    spacing: 2

                                    Text {
                                        text: netRow.modelData.name
                                        color: "#cdd6f4"
                                        font.pixelSize: 12
                                        font.bold: netRow.modelData.connected
                                        elide: Text.ElideRight
                                        width: parent.width
                                    }

                                    Row {
                                        spacing: 6

                                        Text {
                                            text: netRow.modelData.connected     ? "Connected"
                                                : netRow.modelData.stateChanging ? "Working..."
                                                : netRow.modelData.known         ? "Saved"
                                                :                                  "Nearby"
                                            color: netRow.modelData.connected ? "#00ff99"
                                                 : netRow.modelData.stateChanging ? "#f9e2af"
                                                 : "#6c7086"
                                            font.pixelSize: 10
                                        }

                                        Text {
                                            text: "· " + Math.round(netRow.modelData.signalStrength) + "%"
                                            color: "#6c7086"
                                            font.pixelSize: 10
                                        }
                                    }
                                }

                                Row {
                                    spacing: 4

                                    Rectangle {
                                        width: netActionLabel.implicitWidth + 16
                                        height: 26
                                        radius: 6
                                        color: netActionMa.containsMouse ? "#313244" : "#1a1a2e"
                                        border.color: netRow.modelData.connected ? "#f38ba8" : "#33ccff"
                                        border.width: 1
                                        Behavior on color { ColorAnimation { duration: 80 } }

                                        Text {
                                            id: netActionLabel
                                            anchors.centerIn: parent
                                            text: netRow.modelData.connected     ? "Disconnect"
                                                : netRow.modelData.stateChanging ? "..."
                                                :                                  "Connect"
                                            color: netRow.modelData.connected ? "#f38ba8" : "#33ccff"
                                            font.pixelSize: 10
                                        }

                                        MouseArea {
                                            id: netActionMa
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            enabled: !netRow.modelData.stateChanging
                                            onClicked: {
                                                const net = netRow.modelData
                                                if (net.connected) {
                                                    net.disconnect()
                                                } else if (net.known || root.isOpen(net)) {
                                                    net.connect()
                                                } else {
                                                    root.pendingNetwork = (root.pendingNetwork === net) ? null : net
                                                }
                                            }
                                        }
                                    }

                                    Rectangle {
                                        width: 26; height: 26; radius: 6
                                        visible: netRow.modelData.known && !netRow.modelData.connected
                                        color: forgetMa.containsMouse ? "#3a1a1a" : "#1a1a2e"
                                        border.color: "#f38ba8"
                                        border.width: 1
                                        Behavior on color { ColorAnimation { duration: 80 } }

                                        Text { anchors.centerIn: parent; text: "🗑"; font.pixelSize: 11 }

                                        MouseArea {
                                            id: forgetMa
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: netRow.modelData.forget()
                                        }
                                    }
                                }
                            }
                        }

                        // Inline password prompt for unknown secured networks
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.topMargin: 4
                            visible: root.pendingNetwork === netRow.modelData
                            height: visible ? 40 : 0
                            radius: 8
                            color: "#1a1a2e"
                            border.color: "#33ccff"
                            border.width: 1
                            clip: true

                            RowLayout {
                                anchors { fill: parent; margins: 6 }
                                spacing: 6

                                Rectangle {
                                    Layout.fillWidth: true
                                    height: 26
                                    radius: 6
                                    color: "#11111b"
                                    border.color: "#313244"
                                    border.width: 1

                                    TextInput {
                                        id: pskInput
                                        anchors { fill: parent; margins: 8 }
                                        verticalAlignment: TextInput.AlignVCenter
                                        color: "#cdd6f4"
                                        font.pixelSize: 11
                                        echoMode: TextInput.Password
                                        focus: root.pendingNetwork === netRow.modelData
                                        onAccepted: {
                                            netRow.modelData.connectWithPsk(text)
                                            root.pendingNetwork = null
                                            text = ""
                                        }
                                    }
                                }

                                Rectangle {
                                    width: 50; height: 26; radius: 6
                                    color: connectMa.containsMouse ? "#2a9d6f" : "#00ff99"
                                    Text { anchors.centerIn: parent; text: "Join"; color: "#11111b"; font.pixelSize: 10; font.bold: true }
                                    MouseArea {
                                        id: connectMa
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            netRow.modelData.connectWithPsk(pskInput.text)
                                            root.pendingNetwork = null
                                            pskInput.text = ""
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Text {
                    Layout.fillWidth: true
                    Layout.bottomMargin: 4
                    text: "No networks found.\nEnable scanning to discover nearby networks."
                    visible: Networking.wifiEnabled && (root.wifiDevice?.networks?.values?.length === 0)
                    color: "#6c7086"
                    font.pixelSize: 11
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                }
            }
        }
    }
}
