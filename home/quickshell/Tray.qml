pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

RowLayout {
    spacing: 2

    Repeater {
        model: SystemTray.items

        delegate: Item {
            id: trayItem
            required property SystemTrayItem modelData

            Layout.preferredWidth: 24
            Layout.preferredHeight: 24

            Rectangle {
                anchors.fill: parent
                radius: 4
                color: trayMouse.containsMouse ? "#1e1e2e" : "transparent"

                Behavior on color { ColorAnimation { duration: 80 } }

                Image {
                    anchors.centerIn: parent
                    width: 18
                    height: 18
                    source: trayItem.modelData.icon
                    smooth: true
                    mipmap: true
                }
            }

            MouseArea {
                id: trayMouse
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                cursorShape: Qt.PointingHandCursor

                onClicked: mouse => {
                    if (mouse.button === Qt.LeftButton)
                        trayItem.modelData.activate()
                }
            }
        }
    }
}
