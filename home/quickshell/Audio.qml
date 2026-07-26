pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Services.Pipewire

Item {
    id: root

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property real volume: sink?.audio?.volume ?? 0
    readonly property bool muted: sink?.audio?.muted ?? false

    implicitWidth: row.implicitWidth + 12
    implicitHeight: 28

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 4

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.muted ? "✕" : "♪"
            color: root.muted ? "#f38ba8" : "#33ccff"
            font.pixelSize: 14
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.muted ? "mute" : Math.round(root.volume * 100) + "%"
            color: root.muted ? "#f38ba8" : "#cdd6f4"
            font.pixelSize: 11
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton
        onClicked: {
            if (root.sink?.audio)
                root.sink.audio.muted = !root.sink.audio.muted
        }
        onWheel: event => {
            if (root.sink?.audio) {
                const delta = event.angleDelta.y > 0 ? 0.05 : -0.05
                root.sink.audio.volume = Math.max(0, Math.min(1.0, root.volume + delta))
            }
        }
    }
}
