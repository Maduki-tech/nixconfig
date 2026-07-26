import QtQuick

Item {
    implicitWidth: col.implicitWidth
    implicitHeight: col.implicitHeight

    Column {
        id: col
        anchors.centerIn: parent
        spacing: 1

        Text {
            id: timeText
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#cdd6f4"
            font.pixelSize: 13
            font.bold: true
        }

        Text {
            id: dateText
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#a6adc8"
            font.pixelSize: 10
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            const now = new Date()
            timeText.text = now.toLocaleTimeString(Qt.locale(), "HH:mm:ss")
            dateText.text = now.toLocaleDateString(Qt.locale(), "ddd, dd. MMM")
        }
    }
}
