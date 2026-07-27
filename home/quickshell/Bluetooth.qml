import QtQuick
import QtQuick.Layouts
import Quickshell.Bluetooth

Item {
    id: root
    signal clicked()

    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property bool btEnabled: adapter?.enabled ?? false
    readonly property int connectedCount: {
        let count = 0
        const devs = Bluetooth.devices.values
        for (let i = 0; i < devs.length; i++) {
            if (devs[i]?.connected) count++
        }
        return count
    }

    implicitWidth: row.implicitWidth + 12
    implicitHeight: 28

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 4

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: "⬡"
            color: !root.btEnabled            ? "#f38ba8"
                 : root.connectedCount > 0    ? "#33ccff"
                 :                              "#6c7086"
            font.pixelSize: 13

            Behavior on color { ColorAnimation { duration: 150 } }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: !root.adapter              ? "No BT"
                : !root.btEnabled            ? "BT off"
                : root.connectedCount > 0    ? "BT (" + root.connectedCount + ")"
                :                              "BT"
            color: root.btEnabled ? "#cdd6f4" : "#a6adc8"
            font.pixelSize: 11
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
