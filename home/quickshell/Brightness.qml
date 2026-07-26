import QtQuick
import Quickshell.Io

Item {
    id: root

    property int current: 255
    property int maximum: 255
    readonly property real percent: maximum > 0 ? current / maximum : 1.0

    implicitWidth: row.implicitWidth + 12
    implicitHeight: 28

    Process {
        id: getProc
        command: ["sh", "-c", "echo \"$(brightnessctl get):$(brightnessctl max)\""]
        running: true
        stdout: SplitParser {
            splitMarker: "\n"
            onRead: data => {
                const parts = data.trim().split(":")
                if (parts.length === 2) {
                    root.current = parseInt(parts[0]) || 255
                    root.maximum = parseInt(parts[1]) || 255
                }
            }
        }
        onRunningChanged: if (!running) pollTimer.restart()
    }

    Process {
        id: setProc
        property int pct: 100
        command: ["brightnessctl", "set", setProc.pct + "%"]
        onRunningChanged: if (!running) getProc.running = true
    }

    Timer {
        id: pollTimer
        interval: 10000
        repeat: false
        onTriggered: getProc.running = true
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 4

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: "☀"
            color: "#f9e2af"
            font.pixelSize: 14
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: Math.round(root.percent * 100) + "%"
            color: "#cdd6f4"
            font.pixelSize: 11
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onWheel: event => {
            const delta = event.angleDelta.y > 0 ? 0.05 : -0.05
            const newPct = Math.round(Math.max(1, Math.min(100, (root.percent + delta) * 100)))
            setProc.pct = newPct
            setProc.running = true
            root.current = Math.round(newPct / 100 * root.maximum)
        }
    }
}
