pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.UPower
import Quickshell.Wayland._WlrLayerShell

PanelWindow {
    id: root
    signal close()

    anchors { top: true; right: true }
    margins { top: 44 }
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    implicitWidth: 280
    implicitHeight: card.implicitHeight
    color: "transparent"

    onVisibleChanged: {
        if (visible) {
            focusGrab.active = true
            root.refreshProfiles()
        }
    }

    HyprlandFocusGrab {
        id: focusGrab
        windows: [root]
        onCleared: root.close()
    }

    // ── Power profiles (power-profiles-daemon via powerprofilesctl) ────
    property var profilesAvailable: []
    property string activeProfile: ""
    property string _profileListBuf: ""

    function refreshProfiles() {
        root._profileListBuf = ""
        listProfilesProc.running = true
    }

    function profileLabel(p) {
        switch (p) {
            case "power-saver": return "Eco"
            case "balanced":    return "Balanced"
            case "performance": return "Performance"
            default:            return p
        }
    }

    function setProfile(p) {
        if (p === root.activeProfile) return
        setProfileProc.profile = p
        setProfileProc.running = true
    }

    Process {
        id: listProfilesProc
        command: ["powerprofilesctl", "list"]
        running: false
        stdout: SplitParser {
            splitMarker: "\n"
            onRead: data => root._profileListBuf += data + "\n"
        }
        onRunningChanged: {
            if (running) return
            const profiles = []
            let active = ""
            for (const line of root._profileListBuf.split("\n")) {
                const m = line.match(/^(\*)?\s*([a-z-]+):\s*$/)
                if (!m) continue
                profiles.push(m[2])
                if (m[1]) active = m[2]
            }
            if (profiles.length > 0) {
                root.profilesAvailable = profiles
                root.activeProfile = active || profiles[0]
            }
        }
    }

    Process {
        id: setProfileProc
        property string profile: ""
        command: ["powerprofilesctl", "set", setProfileProc.profile]
        onRunningChanged: if (!running) root.refreshProfiles()
    }

    readonly property var device: UPower.displayDevice
    readonly property bool present: device?.isPresent ?? false
    readonly property real percent: device?.percentage ?? 0
    readonly property int battState: device?.state ?? UPowerDeviceState.Unknown

    readonly property bool charging: battState === UPowerDeviceState.Charging
                                   || battState === UPowerDeviceState.PendingCharge
    readonly property bool full: battState === UPowerDeviceState.FullyCharged
    readonly property bool discharging: battState === UPowerDeviceState.Discharging

    readonly property string statusText: !present    ? "No battery"
                                        : full         ? "Fully charged"
                                        : charging     ? "Charging"
                                        : discharging  ? "On battery"
                                        :                "Idle"

    readonly property string levelColor: charging || full ? "#00ff99"
                                        : percent <= 0.15  ? "#f38ba8"
                                        : percent <= 0.30  ? "#f9e2af"
                                        :                    "#33ccff"

    function formatTime(seconds) {
        if (!seconds || seconds <= 0) return ""
        const h = Math.floor(seconds / 3600)
        const m = Math.round((seconds % 3600) / 60)
        return h > 0 ? (h + "h " + m + "m") : (m + "m")
    }

    readonly property string timeText: charging && device?.timeToFull > 0
                                        ? formatTime(device.timeToFull) + " until full"
                                        : discharging && device?.timeToEmpty > 0
                                        ? formatTime(device.timeToEmpty) + " remaining"
                                        : ""

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
                    text: "Battery"
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
            }

            // ── Divider ─────────────────────────────────────────────
            Rectangle { Layout.fillWidth: true; height: 1; color: "#313244" }

            // ── No battery message ──────────────────────────────────
            Text {
                Layout.fillWidth: true
                Layout.bottomMargin: 4
                text: "No battery detected on this system."
                visible: !root.present
                color: "#6c7086"
                font.pixelSize: 12
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }

            // ── Overview ─────────────────────────────────────────────
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 12
                visible: root.present

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    Text {
                        text: Math.round(root.percent * 100) + "%"
                        color: root.levelColor
                        font.pixelSize: 28
                        font.bold: true
                    }

                    ColumnLayout {
                        spacing: 2
                        Text {
                            text: root.statusText
                            color: "#cdd6f4"
                            font.pixelSize: 12
                        }
                        Text {
                            text: root.timeText
                            visible: root.timeText !== ""
                            color: "#6c7086"
                            font.pixelSize: 11
                        }
                    }
                }

                // Level bar
                Rectangle {
                    Layout.fillWidth: true
                    height: 8
                    radius: 4
                    color: "#1e1e2e"

                    Rectangle {
                        anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
                        width: parent.width * root.percent
                        radius: 4
                        color: root.levelColor
                        Behavior on width { NumberAnimation { duration: 200 } }
                    }
                }

                // Details
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 6

                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "Health"; color: "#6c7086"; font.pixelSize: 11 }
                        Item { Layout.fillWidth: true }
                        Text {
                            text: root.device?.healthSupported ? Math.round(root.device.healthPercentage) + "%" : "N/A"
                            color: "#cdd6f4"
                            font.pixelSize: 11
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        visible: (root.device?.model ?? "") !== ""
                        Text { text: "Model"; color: "#6c7086"; font.pixelSize: 11 }
                        Item { Layout.fillWidth: true }
                        Text {
                            text: root.device?.model ?? ""
                            color: "#cdd6f4"
                            font.pixelSize: 11
                            elide: Text.ElideRight
                        }
                    }
                }

                // ── Power profile ────────────────────────────────────
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 8
                    visible: root.profilesAvailable.length > 0

                    Rectangle { Layout.fillWidth: true; height: 1; color: "#313244" }

                    Text { text: "Power Profile"; color: "#6c7086"; font.pixelSize: 11 }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 6

                        Repeater {
                            model: root.profilesAvailable

                            delegate: Rectangle {
                                id: profBtn
                                required property string modelData

                                readonly property bool active: modelData === root.activeProfile

                                Layout.fillWidth: true
                                height: 32
                                radius: 8
                                color: profBtn.active ? "#33ccff" : (profMa.containsMouse ? "#313244" : "#1e1e2e")
                                border.color: profBtn.active ? "#33ccff" : "#313244"
                                border.width: 1
                                Behavior on color { ColorAnimation { duration: 80 } }

                                Text {
                                    anchors.centerIn: parent
                                    text: root.profileLabel(profBtn.modelData)
                                    color: profBtn.active ? "#11111b" : "#cdd6f4"
                                    font.pixelSize: 11
                                    font.bold: profBtn.active
                                }

                                MouseArea {
                                    id: profMa
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: root.setProfile(profBtn.modelData)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
