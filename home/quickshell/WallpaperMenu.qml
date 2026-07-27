pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland._WlrLayerShell

PanelWindow {
    id: root
    signal close()

    anchors { top: true; bottom: true; left: true; right: true }
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    color: Qt.rgba(0, 0, 0, 0.55)

    property var images: []
    property string currentWallpaper: ""

    function refresh() {
        root.images = []
        root.currentWallpaper = ""
        listProc.running = true
        currentProc.running = true
    }

    function selectWallpaper(path) {
        root.currentWallpaper = path
        setProc.path = path
        setProc.running = true

        // Wallpapers directly in Wallpapers/ have no theme mapping.
        // Wallpapers under Wallpapers/<theme>/<file> switch to <theme>.
        const parts = path.split("/")
        const theme = parts.length >= 2 ? parts[parts.length - 2] : ""
        if (theme !== "" && theme !== "Wallpapers") {
            themeProc.theme = theme
            themeProc.running = true
        }
    }

    function openFolder() {
        openProc.running = true
    }

    // ── List images directly in Wallpapers/ and in Wallpapers/<theme>/ ──
    Process {
        id: listProc
        command: ["sh", "-c",
            "find \"$HOME/Pictures/Wallpapers\" -mindepth 1 -maxdepth 2 -type f " +
            "\\( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' -o -iname '*.bmp' -o -iname '*.gif' \\) " +
            "2>/dev/null | sort"]
        running: false
        stdout: SplitParser {
            splitMarker: "\n"
            onRead: data => {
                if (data.trim() !== "") root.images = [...root.images, data]
            }
        }
    }

    // ── Read the currently displayed wallpaper straight from awww ───
    Process {
        id: currentProc
        command: ["awww", "query"]
        running: false
        stdout: SplitParser {
            splitMarker: "\n"
            onRead: data => {
                const m = data.match(/currently displaying: image: (.+)$/)
                if (m) root.currentWallpaper = m[1].trim()
            }
        }
    }

    // ── Apply the chosen wallpaper via awww (persisted automatically ──
    // ── by awww-daemon's own cache across restarts/reboots) ─────────
    Process {
        id: setProc
        property string path: ""
        command: ["awww", "img", setProc.path,
            "--transition-type", "wipe",
            "--transition-fps", "60",
            "--transition-duration", "0.5"]
    }

    Process {
        id: openProc
        command: ["sh", "-c",
            "xdg-open \"$HOME/Pictures/Wallpapers\" >/dev/null 2>&1 &"]
    }

    // ── Apply the theme mapped to the wallpaper's parent folder ─────
    Process {
        id: themeProc
        property string theme: ""
        command: ["theme-set", themeProc.theme]
    }

    onVisibleChanged: if (visible) root.refresh()

    Item {
        anchors.fill: parent
        focus: true
        Keys.onEscapePressed: root.close()

        // Dim overlay — click outside to close
        MouseArea {
            anchors.fill: parent
            onClicked: root.close()

            // Picker card
            Rectangle {
                anchors.centerIn: parent
                width: 760
                height: Math.min(600, parent.height - 80)
                radius: 12
                color: "#11111b"
                border.color: "#33ccff"
                border.width: 1

                // Block outer MouseArea
                MouseArea { anchors.fill: parent }

                ColumnLayout {
                    anchors { fill: parent; margins: 16 }
                    spacing: 12

                    // Header
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            text: "Choose Wallpaper"
                            color: "#cdd6f4"
                            font.pixelSize: 14
                            font.bold: true
                        }

                        Text {
                            text: "~/Pictures/Wallpapers"
                            color: "#6c7086"
                            font.pixelSize: 11
                        }

                        Item { Layout.fillWidth: true }

                        Rectangle {
                            width: folderLabel.implicitWidth + 16
                            height: 24
                            radius: 6
                            color: folderMa.containsMouse ? "#313244" : "#1e1e2e"
                            border.color: "#313244"
                            border.width: 1
                            Behavior on color { ColorAnimation { duration: 80 } }

                            Text {
                                id: folderLabel
                                anchors.centerIn: parent
                                text: "Open folder"
                                color: "#a6adc8"
                                font.pixelSize: 11
                            }

                            MouseArea {
                                id: folderMa
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.openFolder()
                            }
                        }

                        Rectangle {
                            width: 22; height: 22; radius: 11
                            color: closeMa.containsMouse ? "#313244" : "transparent"
                            Behavior on color { ColorAnimation { duration: 80 } }
                            Text { anchors.centerIn: parent; text: "✕"; color: "#6c7086"; font.pixelSize: 11 }
                            MouseArea { id: closeMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: root.close() }
                        }
                    }

                    Rectangle { Layout.fillWidth: true; height: 1; color: "#313244" }

                    // Empty state
                    Text {
                        Layout.fillWidth: true
                        Layout.topMargin: 24
                        visible: root.images.length === 0
                        text: "No images found in ~/Pictures/Wallpapers/.\nAdd pictures there, or into a ~/Pictures/Wallpapers/<theme>/ subfolder to auto-switch themes."
                        color: "#6c7086"
                        font.pixelSize: 12
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                    }

                    // Thumbnail grid
                    GridView {
                        id: grid
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        visible: root.images.length > 0
                        cellWidth: 176
                        cellHeight: 116
                        model: root.images

                        ScrollBar.vertical: ScrollBar {}

                        delegate: Item {
                            id: cell
                            required property string modelData

                            readonly property bool active: cell.modelData === root.currentWallpaper

                            width: grid.cellWidth
                            height: grid.cellHeight

                            Rectangle {
                                anchors.fill: parent
                                anchors.margins: 6
                                radius: 10
                                clip: true
                                color: "#1e1e2e"
                                border.width: cell.active ? 2 : 1
                                border.color: cell.active ? "#33ccff" : "#313244"

                                Image {
                                    anchors.fill: parent
                                    anchors.margins: 2
                                    source: "file://" + cell.modelData
                                    fillMode: Image.PreserveAspectCrop
                                    asynchronous: true
                                    cache: true
                                    sourceSize.width: 240
                                    sourceSize.height: 160
                                }

                                Rectangle {
                                    visible: cell.active
                                    anchors { top: parent.top; right: parent.right; margins: 6 }
                                    width: 18; height: 18; radius: 9
                                    color: "#33ccff"

                                    Text {
                                        anchors.centerIn: parent
                                        text: "✓"
                                        color: "#11111b"
                                        font.pixelSize: 10
                                        font.bold: true
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: root.selectWallpaper(cell.modelData)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
