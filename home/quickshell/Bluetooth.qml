import QtQuick
import Quickshell.Io

Item {
    id: root

    property bool powered: false
    property int devicesConnected: 0

    implicitWidth: row.implicitWidth + 12
    implicitHeight: 28

    Process {
        id: btToggleProc
        property string btCmd: "power off"
        command: ["sh", "-c", "bluetoothctl " + btToggleProc.btCmd]
        onRunningChanged: if (!running) btProc.running = true
    }

    Process {
        id: btProc
        command: ["sh", "-c",
            "POWERED=$(bluetoothctl show 2>/dev/null | awk '/Powered:/{print $2}'); " +
            "DEVS=$(bluetoothctl devices Connected 2>/dev/null | wc -l | tr -d ' '); " +
            "echo \"$POWERED:$DEVS\""]
        running: true
        stdout: SplitParser {
            splitMarker: "\n"
            onRead: data => {
                const parts = data.trim().split(":")
                root.powered = parts[0] === "yes"
                root.devicesConnected = parseInt(parts[1]) || 0
            }
        }
        onRunningChanged: if (!running) pollTimer.restart()
    }

    Timer {
        id: pollTimer
        interval: 15000
        repeat: false
        onTriggered: btProc.running = true
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 4

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: "⬡"
            color: root.powered
                   ? (root.devicesConnected > 0 ? "#33ccff" : "#6c7086")
                   : "#f38ba8"
            font.pixelSize: 13
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: !root.powered           ? "BT off"
                : root.devicesConnected > 0 ? "BT (" + root.devicesConnected + ")"
                :                             "BT"
            color: root.powered ? "#cdd6f4" : "#a6adc8"
            font.pixelSize: 11
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            btToggleProc.btCmd = root.powered ? "power off" : "power on"
            btToggleProc.running = true
            root.powered = !root.powered
        }
    }
}
