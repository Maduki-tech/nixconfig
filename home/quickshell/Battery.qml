import QtQuick
import Quickshell.Services.UPower

Item {
    id: root
    signal clicked()

    readonly property var device: UPower.displayDevice
    readonly property bool present: device?.isPresent ?? false
    readonly property real percent: device?.percentage ?? 0
    readonly property int battState: device?.state ?? UPowerDeviceState.Unknown

    readonly property bool charging: battState === UPowerDeviceState.Charging
                                   || battState === UPowerDeviceState.PendingCharge
    readonly property bool full: battState === UPowerDeviceState.FullyCharged

    readonly property string levelColor: charging || full ? "#00ff99"
                                        : percent <= 0.15  ? "#f38ba8"
                                        : percent <= 0.30  ? "#f9e2af"
                                        :                    "#cdd6f4"

    visible: present
    implicitWidth: present ? row.implicitWidth + 12 : 0
    implicitHeight: 28

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 4

        // Battery glyph: outline body + tip + fill level
        Item {
            id: glyph
            width: 20
            height: 11
            anchors.verticalCenter: parent.verticalCenter

            Rectangle {
                id: body
                anchors.fill: parent
                anchors.rightMargin: 2
                radius: 2
                color: "transparent"
                border.color: root.levelColor
                border.width: 1.4

                Rectangle {
                    anchors {
                        left: parent.left
                        top: parent.top
                        bottom: parent.bottom
                        margins: 2
                    }
                    width: Math.max(1, (parent.width - 4) * root.percent)
                    radius: 1
                    color: root.levelColor
                    Behavior on width { NumberAnimation { duration: 200 } }
                }
            }

            // Tip nub
            Rectangle {
                anchors { left: body.right; verticalCenter: body.verticalCenter }
                width: 2
                height: 5
                radius: 1
                color: root.levelColor
            }

            Text {
                anchors.centerIn: body
                visible: root.charging
                text: "⚡"
                font.pixelSize: 8
                color: "#11111b"
            }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: Math.round(root.percent * 100) + "%"
            color: root.levelColor
            font.pixelSize: 11
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
