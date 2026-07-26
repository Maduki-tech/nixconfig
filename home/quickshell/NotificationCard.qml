import QtQuick
import QtQuick.Layouts

Rectangle {
    id: card

    signal closeRequested()
    property var notification: null

    radius: 10
    color: "#1e1e2e"
    border.color: urgencyColor
    border.width: 1
    height: cardLayout.implicitHeight + 20
    clip: true

    readonly property color urgencyColor:
        !notification ? "#313244"
        : notification.urgency === 2 ? "#f38ba8"
        : notification.urgency === 0 ? "#6c7086"
        : "#33ccff"

    layer.enabled: true
    layer.effect: null

    RowLayout {
        id: cardLayout
        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
            leftMargin: 12
            rightMargin: 12
        }
        spacing: 10

        Column {
            Layout.fillWidth: true
            spacing: 3

            Text {
                text: card.notification?.appName ?? ""
                color: "#6c7086"
                font.pixelSize: 10
                visible: text !== ""
            }

            Text {
                text: card.notification?.summary || card.notification?.appName || "Notification"
                color: "#cdd6f4"
                font.pixelSize: 12
                font.bold: true
                wrapMode: Text.WordWrap
                width: parent.width
            }

            Text {
                text: card.notification?.body ?? ""
                color: "#a6adc8"
                font.pixelSize: 11
                wrapMode: Text.WordWrap
                width: parent.width
                visible: text !== ""
            }
        }

        Rectangle {
            width: 20
            height: 20
            radius: 10
            color: closeMouse.containsMouse ? "#f38ba8" : "#313244"

            Behavior on color { ColorAnimation { duration: 80 } }

            Text {
                anchors.centerIn: parent
                text: "✕"
                color: closeMouse.containsMouse ? "#11111b" : "#6c7086"
                font.pixelSize: 10
            }

            MouseArea {
                id: closeMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: closeRequested()
            }
        }
    }

    Timer {
        interval: card.notification?.urgency === 2 ? 10000 : 5000
        running: card.notification !== null
        onTriggered: closeRequested()
    }

    NumberAnimation on opacity {
        id: fadeIn
        from: 0; to: 1
        duration: 200
        running: true
    }
}
