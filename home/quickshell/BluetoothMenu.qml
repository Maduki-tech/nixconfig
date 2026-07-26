pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Wayland._WlrLayerShell

PanelWindow {
    id: root
    signal close()

    anchors { top: true; right: true }
    margins { top: 44 }
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    implicitWidth: 300
    implicitHeight: card.implicitHeight
    color: "transparent"

    readonly property var adapter: Bluetooth.defaultAdapter

    function deviceIcon(icon) {
        if (!icon) return "◉"
        if (icon.includes("headphones") || icon.includes("headset")) return "🎧"
        if (icon.includes("mouse"))    return "🖱"
        if (icon.includes("phone"))    return "📱"
        if (icon.includes("keyboard")) return "⌨"
        if (icon.includes("gaming") || icon.includes("joystick")) return "🎮"
        if (icon.includes("audio"))    return "🔊"
        if (icon.includes("computer")) return "💻"
        return "◉"
    }

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
                    text: "Bluetooth"
                    color: "#cdd6f4"
                    font.pixelSize: 14
                    font.bold: true
                }

                Text {
                    text: root.adapter
                          ? (root.adapter.discovering ? "Scanning..." : root.adapter.enabled ? "On" : "Off")
                          : "Unavailable"
                    color: "#6c7086"
                    font.pixelSize: 11
                }

                Item { Layout.fillWidth: true }

                // Close button
                Rectangle {
                    width: 22; height: 22; radius: 11
                    color: closeMa.containsMouse ? "#313244" : "transparent"
                    Behavior on color { ColorAnimation { duration: 80 } }
                    Text { anchors.centerIn: parent; text: "✕"; color: "#6c7086"; font.pixelSize: 11 }
                    MouseArea { id: closeMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: root.close() }
                }

                // Power toggle switch
                Rectangle {
                    width: 42; height: 22; radius: 11
                    color: root.adapter?.enabled ? "#33ccff" : "#313244"
                    Behavior on color { ColorAnimation { duration: 150 } }
                    opacity: root.adapter ? 1 : 0.4

                    Rectangle {
                        id: thumb
                        width: 18; height: 18; radius: 9
                        anchors.verticalCenter: parent.verticalCenter
                        x: root.adapter?.enabled ? parent.width - width - 2 : 2
                        color: "#cdd6f4"
                        Behavior on x { NumberAnimation { duration: 150; easing.type: Easing.InOutQuad } }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        enabled: root.adapter !== null
                        onClicked: root.adapter.enabled = !root.adapter.enabled
                    }
                }
            }

            // ── Divider ─────────────────────────────────────────────
            Rectangle { Layout.fillWidth: true; height: 1; color: "#313244" }

            // ── Scan button ─────────────────────────────────────────
            Rectangle {
                Layout.fillWidth: true
                height: 34
                radius: 8
                visible: root.adapter?.enabled ?? false
                color: scanMa.containsMouse
                       ? (root.adapter?.discovering ? "#1a3a28" : "#1e2a3a")
                       : (root.adapter?.discovering ? "#152d20" : "#1e1e2e")
                border.color: root.adapter?.discovering ? "#00ff99" : "#313244"
                border.width: 1
                Behavior on color { ColorAnimation { duration: 80 } }

                Text {
                    anchors.centerIn: parent
                    text: root.adapter?.discovering ? "⬤  Scanning for devices..." : "⊕  Scan for devices"
                    color: root.adapter?.discovering ? "#00ff99" : "#a6adc8"
                    font.pixelSize: 12
                }

                MouseArea {
                    id: scanMa
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: if (root.adapter) root.adapter.discovering = !root.adapter.discovering
                }
            }

            // ── No adapter / BT disabled message ────────────────────
            Text {
                Layout.fillWidth: true
                Layout.bottomMargin: 4
                text: !root.adapter ? "No Bluetooth adapter found."
                    : !root.adapter.enabled ? "Enable Bluetooth to see devices."
                    : ""
                visible: text !== ""
                color: "#6c7086"
                font.pixelSize: 12
                horizontalAlignment: Text.AlignHCenter
            }

            // ── Device list ─────────────────────────────────────────
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4
                visible: root.adapter?.enabled ?? false

                Repeater {
                    model: Bluetooth.devices

                    delegate: Rectangle {
                        id: devRow
                        required property BluetoothDevice modelData

                        Layout.fillWidth: true
                        height: 52
                        radius: 8
                        color: "#1e1e2e"
                        visible: true

                        // Left: icon + name + status
                        RowLayout {
                            anchors { fill: parent; leftMargin: 10; rightMargin: 10 }
                            spacing: 10

                            Text {
                                text: root.deviceIcon(devRow.modelData.icon)
                                font.pixelSize: 20
                            }

                            Column {
                                Layout.fillWidth: true
                                spacing: 2

                                Text {
                                    text: devRow.modelData.name || devRow.modelData.address
                                    color: "#cdd6f4"
                                    font.pixelSize: 12
                                    font.bold: devRow.modelData.connected
                                    elide: Text.ElideRight
                                    width: parent.width
                                }

                                Row {
                                    spacing: 6

                                    Text {
                                        text: devRow.modelData.connected    ? "Connected"
                                            : devRow.modelData.pairing      ? "Pairing..."
                                            : devRow.modelData.paired       ? "Paired"
                                            : "Nearby"
                                        color: devRow.modelData.connected ? "#00ff99"
                                             : devRow.modelData.pairing   ? "#f9e2af"
                                             : "#6c7086"
                                        font.pixelSize: 10
                                    }

                                    Text {
                                        text: devRow.modelData.batteryAvailable
                                              ? "· " + devRow.modelData.battery + "%"
                                              : ""
                                        visible: devRow.modelData.batteryAvailable
                                        color: devRow.modelData.battery < 20 ? "#f38ba8" : "#6c7086"
                                        font.pixelSize: 10
                                    }
                                }
                            }

                            // Action buttons
                            Row {
                                spacing: 4

                                // Connect / Disconnect / Pair / Cancel
                                Rectangle {
                                    width: actionLabel.implicitWidth + 16
                                    height: 26
                                    radius: 6
                                    color: actionMa.containsMouse ? "#313244" : "#1a1a2e"
                                    border.color: devRow.modelData.connected ? "#f38ba8" : "#33ccff"
                                    border.width: 1
                                    Behavior on color { ColorAnimation { duration: 80 } }

                                    Text {
                                        id: actionLabel
                                        anchors.centerIn: parent
                                        text: devRow.modelData.connected ? "Disconnect"
                                            : devRow.modelData.pairing   ? "Cancel"
                                            : devRow.modelData.paired    ? "Connect"
                                            : "Pair"
                                        color: devRow.modelData.connected ? "#f38ba8" : "#33ccff"
                                        font.pixelSize: 10
                                    }

                                    MouseArea {
                                        id: actionMa
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            const dev = devRow.modelData
                                            if (dev.connected)   dev.disconnect()
                                            else if (dev.pairing) dev.cancelPair()
                                            else if (dev.paired)  dev.connect()
                                            else                  dev.pair()
                                        }
                                    }
                                }

                                // Forget button (only for paired devices)
                                Rectangle {
                                    width: 26; height: 26; radius: 6
                                    visible: devRow.modelData.paired && !devRow.modelData.connected
                                    color: forgetMa.containsMouse ? "#3a1a1a" : "#1a1a2e"
                                    border.color: "#f38ba8"
                                    border.width: 1
                                    Behavior on color { ColorAnimation { duration: 80 } }

                                    Text {
                                        anchors.centerIn: parent
                                        text: "🗑"
                                        font.pixelSize: 11
                                    }

                                    MouseArea {
                                        id: forgetMa
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: devRow.modelData.forget()
                                    }
                                }
                            }
                        }
                    }
                }

                // Empty state when BT is on but no devices
                Text {
                    Layout.fillWidth: true
                    Layout.bottomMargin: 4
                    text: "No devices found.\nEnable scanning to discover nearby devices."
                    visible: Bluetooth.devices.values?.length === 0
                    color: "#6c7086"
                    font.pixelSize: 11
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                }
            }
        }
    }
}
