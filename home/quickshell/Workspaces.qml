pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

RowLayout {
    spacing: 4

    Repeater {
        model: Hyprland.workspaces

        delegate: Item {
            id: wsItem
            required property var modelData

            readonly property bool active:
                Hyprland.focusedMonitor?.activeWorkspace?.id === modelData.id

            Layout.preferredWidth: 28
            Layout.preferredHeight: 28

            Rectangle {
                anchors.fill: parent
                radius: 6
                color: wsItem.active ? "#33ccff" : "#1e1e2e"

                Behavior on color { ColorAnimation { duration: 120 } }

                Text {
                    anchors.centerIn: parent
                    text: wsItem.modelData.id
                    color: wsItem.active ? "#11111b" : "#cdd6f4"
                    font.pixelSize: 11
                    font.bold: wsItem.active
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Hyprland.dispatch("workspace " + wsItem.modelData.id)
            }
        }
    }
}
