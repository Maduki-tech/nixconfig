pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland._WlrLayerShell
import Quickshell.Services.Notifications

Item {
    id: root

    property var notifs: []

    NotificationServer {
        id: server
        keepOnReload: true

        onNotification: notif => {
            root.notifs = [...root.notifs, notif]
            notif.closed.connect(() => {
                root.notifs = root.notifs.filter(n => n !== notif)
            })
        }
    }

    PanelWindow {
        id: notifWindow
        visible: root.notifs.length > 0

        anchors {
            top: true
            right: true
        }

        implicitWidth: 320
        implicitHeight: notifCol.implicitHeight + 16
        color: "transparent"

        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

        Column {
            id: notifCol
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                topMargin: 8
                leftMargin: 8
                rightMargin: 8
            }
            spacing: 6

            Repeater {
                model: root.notifs.length

                delegate: NotificationCard {
                    required property int index
                    notification: root.notifs[index]
                    width: notifCol.width
                    onCloseRequested: {
                        const notif = root.notifs[index]
                        root.notifs = root.notifs.filter(n => n !== notif)
                        notif?.expire()
                    }
                }
            }
        }
    }
}
