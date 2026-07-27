pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland._WlrLayerShell
import Quickshell.Services.Pipewire

Item {
    id: root

    // ── Audio tracking ───────────────────────────────────────────────
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property real volume: sink?.audio?.volume ?? 0
    readonly property bool muted: sink?.audio?.muted ?? false

    // ── Brightness tracking ──────────────────────────────────────────
    property int brightCurrent: 0
    property int brightMax: 255
    readonly property real brightPercent: brightMax > 0 ? brightCurrent / brightMax : 1.0

    // ── OSD state ─────────────────────────────────────────────────────
    property bool ready: false
    property bool shown: false
    property string mode: "volume"
    property real level: 0
    property bool osdMuted: false

    readonly property color accent: mode === "brightness" ? "#f9e2af" : (osdMuted ? "#f38ba8" : "#33ccff")
    readonly property string glyph: mode === "brightness" ? "☀" : (osdMuted ? "✕" : "♪")

    // Skip the change notifications that fire while services first connect.
    Component.onCompleted: readyTimer.start()
    Timer { id: readyTimer; interval: 400; onTriggered: root.ready = true }

    function present(newMode, newLevel, newMuted) {
        root.mode = newMode
        root.level = Math.max(0, Math.min(1, newLevel))
        root.osdMuted = newMuted
        unmapTimer.stop()
        osdWindow.visible = true
        root.shown = true
        hideTimer.restart()
    }

    onVolumeChanged: if (root.ready) root.present("volume", root.volume, root.muted)
    onMutedChanged: if (root.ready) root.present("volume", root.volume, root.muted)

    Timer {
        id: hideTimer
        interval: 1400
        onTriggered: root.shown = false
    }

    // Keep the window mapped until the hide animation finishes.
    onShownChanged: if (!root.shown) unmapTimer.restart()

    Timer {
        id: unmapTimer
        interval: 260
        onTriggered: osdWindow.visible = false
    }

    // ── Brightness discovery + live watch via sysfs ──────────────────
    Process {
        id: findBacklight
        command: ["sh", "-c", "ls /sys/class/backlight 2>/dev/null | head -n1"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                const name = data.trim()
                if (!name) return
                maxBrightnessFile.path = "/sys/class/backlight/" + name + "/max_brightness"
                brightnessFile.path = "/sys/class/backlight/" + name + "/brightness"
            }
        }
    }

    FileView {
        id: maxBrightnessFile
        onLoaded: root.brightMax = parseInt(text()) || 255
    }

    FileView {
        id: brightnessFile
        watchChanges: true
        onLoaded: {
            const v = parseInt(text()) || 0
            const changed = v !== root.brightCurrent
            root.brightCurrent = v
            if (root.ready && changed)
                root.present("brightness", root.brightPercent, false)
        }
        onFileChanged: reload()
    }

    PanelWindow {
        id: osdWindow
        visible: false

        anchors { top: true; bottom: true; right: true }
        exclusiveZone: 0
        implicitWidth: 100
        color: "transparent"

        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

        Rectangle {
            id: card
            width: 60
            height: 190
            radius: 18
            color: "#11111b"
            border.color: root.accent
            border.width: 1

            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: root.shown ? 18 : -90

            opacity: root.shown ? 1 : 0
            scale: root.shown ? 1 : 0.92

            Behavior on anchors.rightMargin {
                NumberAnimation { duration: 240; easing.type: Easing.OutCubic }
            }
            Behavior on opacity {
                NumberAnimation { duration: root.shown ? 120 : 200 }
            }
            Behavior on scale {
                NumberAnimation { duration: 240; easing.type: Easing.OutBack }
            }
            Behavior on border.color {
                ColorAnimation { duration: 150 }
            }

            Column {
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 14
                spacing: 10

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: root.glyph
                    color: root.accent
                    font.pixelSize: 18

                    Behavior on color { ColorAnimation { duration: 150 } }
                }

                Rectangle {
                    id: track
                    width: 10
                    height: 110
                    radius: 5
                    color: "#1e1e2e"
                    anchors.horizontalCenter: parent.horizontalCenter

                    Rectangle {
                        width: parent.width
                        radius: 5
                        color: root.accent
                        anchors.bottom: parent.bottom
                        height: track.height * (root.osdMuted ? 0 : root.level)

                        Behavior on height {
                            NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                        }
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: root.osdMuted ? "mute" : Math.round(root.level * 100) + "%"
                    color: "#cdd6f4"
                    font.pixelSize: 11
                }
            }
        }
    }
}
