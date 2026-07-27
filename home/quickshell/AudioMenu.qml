pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Pipewire
import Quickshell.Wayland._WlrLayerShell

PanelWindow {
    id: root
    signal close()

    anchors { top: true; right: true }
    margins { top: 44 }
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    implicitWidth: 320
    implicitHeight: card.implicitHeight
    color: "transparent"

    onVisibleChanged: if (visible) focusGrab.active = true

    HyprlandFocusGrab {
        id: focusGrab
        windows: [root]
        onCleared: root.close()
    }

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var source: Pipewire.defaultAudioSource

    readonly property var sinks: {
        const nodes = Pipewire.nodes.values
        const result = []
        for (let i = 0; i < nodes.length; i++) {
            const n = nodes[i]
            if (!n.isStream && (n.type & PwNodeType.AudioSink) === PwNodeType.AudioSink)
                result.push(n)
        }
        return result
    }

    readonly property var sources: {
        const nodes = Pipewire.nodes.values
        const result = []
        for (let i = 0; i < nodes.length; i++) {
            const n = nodes[i]
            if (!n.isStream && (n.type & PwNodeType.AudioSource) === PwNodeType.AudioSource)
                result.push(n)
        }
        return result
    }

    PwObjectTracker {
        objects: root.sinks.concat(root.sources)
    }

    function deviceLabel(node) {
        return node?.description || node?.nickname || node?.name || "Unknown device"
    }

    function clamp01(v) {
        return Math.max(0, Math.min(1, v))
    }

    Rectangle {
        id: card
        anchors { top: parent.top; left: parent.left; right: parent.right }
        implicitHeight: col.implicitHeight + 24
        radius: 12
        color: "#11111b"
        border.color: "#33ccff"
        border.width: 1

        ColumnLayout {
            id: col
            anchors { top: parent.top; left: parent.left; right: parent.right; margins: 14 }
            spacing: 10

            // ── Header ──────────────────────────────────────────────
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: "Audio"
                    color: "#cdd6f4"
                    font.pixelSize: 14
                    font.bold: true
                }

                Text {
                    text: root.sink ? "" : "No output device"
                    color: "#f38ba8"
                    font.pixelSize: 11
                }

                Item { Layout.fillWidth: true }

                Rectangle {
                    width: 22; height: 22; radius: 11
                    color: closeMa.containsMouse ? "#313244" : "transparent"
                    Behavior on color { ColorAnimation { duration: 80 } }
                    Text { anchors.centerIn: parent; text: "✕"; color: "#6c7086"; font.pixelSize: 11 }
                    MouseArea { id: closeMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: root.close() }
                }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: "#313244" }

            // ── Output volume ─────────────────────────────────────────
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 6

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8
                    Text { text: "Output"; color: "#6c7086"; font.pixelSize: 11 }
                    Item { Layout.fillWidth: true }
                    Text {
                        text: root.deviceLabel(root.sink)
                        color: "#cdd6f4"
                        font.pixelSize: 11
                        elide: Text.ElideRight
                        Layout.maximumWidth: 180
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Rectangle {
                        width: 26; height: 26; radius: 6
                        color: muteOutMa.containsMouse ? "#313244" : "transparent"
                        Behavior on color { ColorAnimation { duration: 80 } }

                        Text {
                            anchors.centerIn: parent
                            text: (root.sink?.audio?.muted ?? false) ? "✕" : "♪"
                            color: (root.sink?.audio?.muted ?? false) ? "#f38ba8" : "#33ccff"
                            font.pixelSize: 13
                        }

                        MouseArea {
                            id: muteOutMa
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            enabled: !!root.sink?.audio
                            onClicked: root.sink.audio.muted = !root.sink.audio.muted
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 8
                        radius: 4
                        color: "#1e1e2e"

                        Rectangle {
                            anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
                            width: parent.width * root.clamp01(root.sink?.audio?.volume ?? 0)
                            radius: 4
                            color: (root.sink?.audio?.muted ?? false) ? "#6c7086" : "#33ccff"
                        }

                        MouseArea {
                            anchors.fill: parent
                            enabled: !!root.sink?.audio
                            cursorShape: Qt.PointingHandCursor
                            onPressed: mouse => root.sink.audio.volume = root.clamp01(mouse.x / width)
                            onPositionChanged: mouse => { if (pressed) root.sink.audio.volume = root.clamp01(mouse.x / width) }
                            onWheel: event => {
                                const delta = event.angleDelta.y > 0 ? 0.05 : -0.05
                                root.sink.audio.volume = root.clamp01((root.sink.audio.volume ?? 0) + delta)
                            }
                        }
                    }

                    Text {
                        text: Math.round(root.clamp01(root.sink?.audio?.volume ?? 0) * 100) + "%"
                        color: "#cdd6f4"
                        font.pixelSize: 11
                        Layout.preferredWidth: 30
                        horizontalAlignment: Text.AlignRight
                    }
                }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: "#313244" }

            // ── Output device list ────────────────────────────────────
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                Repeater {
                    model: root.sinks

                    delegate: Rectangle {
                        id: sinkRow
                        required property var modelData

                        readonly property bool active: sinkRow.modelData === root.sink

                        Layout.fillWidth: true
                        height: 36
                        radius: 8
                        color: sinkRow.active ? "#16283a" : (sinkMa.containsMouse ? "#1e1e2e" : "transparent")
                        border.color: sinkRow.active ? "#33ccff" : "transparent"
                        border.width: 1
                        Behavior on color { ColorAnimation { duration: 80 } }

                        RowLayout {
                            anchors { fill: parent; leftMargin: 10; rightMargin: 10 }
                            spacing: 8

                            Text {
                                Layout.fillWidth: true
                                text: root.deviceLabel(sinkRow.modelData)
                                color: sinkRow.active ? "#cdd6f4" : "#a6adc8"
                                font.pixelSize: 12
                                font.bold: sinkRow.active
                                elide: Text.ElideRight
                            }

                            Text {
                                visible: sinkRow.active
                                text: "Active"
                                color: "#00ff99"
                                font.pixelSize: 10
                            }
                        }

                        MouseArea {
                            id: sinkMa
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Pipewire.preferredDefaultAudioSink = sinkRow.modelData
                        }
                    }
                }

                Text {
                    Layout.fillWidth: true
                    text: "No output devices found."
                    visible: root.sinks.length === 0
                    color: "#6c7086"
                    font.pixelSize: 11
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: "#313244" }

            // ── Input volume ───────────────────────────────────────────
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 6

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8
                    Text { text: "Input"; color: "#6c7086"; font.pixelSize: 11 }
                    Item { Layout.fillWidth: true }
                    Text {
                        text: root.deviceLabel(root.source)
                        color: "#cdd6f4"
                        font.pixelSize: 11
                        elide: Text.ElideRight
                        Layout.maximumWidth: 180
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Rectangle {
                        width: 26; height: 26; radius: 6
                        color: muteInMa.containsMouse ? "#313244" : "transparent"
                        Behavior on color { ColorAnimation { duration: 80 } }

                        Text {
                            anchors.centerIn: parent
                            text: (root.source?.audio?.muted ?? false) ? "✕" : "◉"
                            color: (root.source?.audio?.muted ?? false) ? "#f38ba8" : "#33ccff"
                            font.pixelSize: 13
                        }

                        MouseArea {
                            id: muteInMa
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            enabled: !!root.source?.audio
                            onClicked: root.source.audio.muted = !root.source.audio.muted
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 8
                        radius: 4
                        color: "#1e1e2e"

                        Rectangle {
                            anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
                            width: parent.width * root.clamp01(root.source?.audio?.volume ?? 0)
                            radius: 4
                            color: (root.source?.audio?.muted ?? false) ? "#6c7086" : "#33ccff"
                        }

                        MouseArea {
                            anchors.fill: parent
                            enabled: !!root.source?.audio
                            cursorShape: Qt.PointingHandCursor
                            onPressed: mouse => root.source.audio.volume = root.clamp01(mouse.x / width)
                            onPositionChanged: mouse => { if (pressed) root.source.audio.volume = root.clamp01(mouse.x / width) }
                            onWheel: event => {
                                const delta = event.angleDelta.y > 0 ? 0.05 : -0.05
                                root.source.audio.volume = root.clamp01((root.source.audio.volume ?? 0) + delta)
                            }
                        }
                    }

                    Text {
                        text: Math.round(root.clamp01(root.source?.audio?.volume ?? 0) * 100) + "%"
                        color: "#cdd6f4"
                        font.pixelSize: 11
                        Layout.preferredWidth: 30
                        horizontalAlignment: Text.AlignRight
                    }
                }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: "#313244" }

            // ── Input device list ─────────────────────────────────────
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                Repeater {
                    model: root.sources

                    delegate: Rectangle {
                        id: sourceRow
                        required property var modelData

                        readonly property bool active: sourceRow.modelData === root.source

                        Layout.fillWidth: true
                        height: 36
                        radius: 8
                        color: sourceRow.active ? "#16283a" : (sourceMa.containsMouse ? "#1e1e2e" : "transparent")
                        border.color: sourceRow.active ? "#33ccff" : "transparent"
                        border.width: 1
                        Behavior on color { ColorAnimation { duration: 80 } }

                        RowLayout {
                            anchors { fill: parent; leftMargin: 10; rightMargin: 10 }
                            spacing: 8

                            Text {
                                Layout.fillWidth: true
                                text: root.deviceLabel(sourceRow.modelData)
                                color: sourceRow.active ? "#cdd6f4" : "#a6adc8"
                                font.pixelSize: 12
                                font.bold: sourceRow.active
                                elide: Text.ElideRight
                            }

                            Text {
                                visible: sourceRow.active
                                text: "Active"
                                color: "#00ff99"
                                font.pixelSize: 10
                            }
                        }

                        MouseArea {
                            id: sourceMa
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Pipewire.preferredDefaultAudioSource = sourceRow.modelData
                        }
                    }
                }

                Text {
                    Layout.fillWidth: true
                    Layout.bottomMargin: 4
                    text: "No input devices found."
                    visible: root.sources.length === 0
                    color: "#6c7086"
                    font.pixelSize: 11
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
    }
}
