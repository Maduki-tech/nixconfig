import QtQuick
import Quickshell.Io

Item {
    id: root

    property string connType: "none"
    property string connName: ""
    readonly property bool connected: connType !== "none"

    implicitWidth: row.implicitWidth + 12
    implicitHeight: 28

    Process {
        id: netProc
        command: ["sh", "-c",
            "nmcli -t -f TYPE,STATE,CONNECTION device 2>/dev/null | grep ':connected:' | head -1"]
        running: true
        stdout: SplitParser {
            splitMarker: "\n"
            onRead: data => {
                const line = data.trim()
                if (line === "") {
                    root.connType = "none"
                    root.connName = ""
                    return
                }
                const parts = line.split(":")
                if (parts.length >= 3) {
                    root.connType = parts[0].toLowerCase().includes("wifi") ? "wifi"
                                  : parts[0].toLowerCase().includes("eth") ? "ethernet"
                                  : "other"
                    root.connName = parts.slice(2).join(":").trim()
                }
            }
        }
        onRunningChanged: {
            if (!running) {
                if (root.connName === "" && root.connType !== "none") root.connType = "none"
                pollTimer.restart()
            }
        }
    }

    Timer {
        id: pollTimer
        interval: 10000
        repeat: false
        onTriggered: netProc.running = true
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 4

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.connType === "wifi"     ? "▲" :
                  root.connType === "ethernet"  ? "⬡" : "○"
            color: root.connected ? "#00ff99" : "#f38ba8"
            font.pixelSize: 13
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.connected ? root.connName : "Offline"
            color: root.connected ? "#cdd6f4" : "#a6adc8"
            font.pixelSize: 11
            elide: Text.ElideRight
            maximumLineCount: 1
        }
    }
}
