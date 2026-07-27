import QtQuick
import QtQuick.Layouts

Item {
    id: root
    signal clicked()

    implicitWidth: row.implicitWidth + 12
    implicitHeight: 28

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 4

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: "🖼"
            font.pixelSize: 13
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: "Wallpaper"
            color: "#cdd6f4"
            font.pixelSize: 11
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
