import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland._WlrLayerShell

PanelWindow {
    id: root
    signal done()

    anchors { top: true; bottom: true; left: true; right: true }
    exclusiveZone: -1
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    WlrLayershell.namespace: "quickshell-screenshot"
    color: "transparent"

    property real selX: 0
    property real selY: 0
    property real selW: 0
    property real selH: 0
    property bool selecting: false

    onVisibleChanged: {
        if (visible) {
            selX = 0; selY = 0; selW = 0; selH = 0
            selecting = false
            focusItem.forceActiveFocus()
        }
    }

    // Frozen frame of this screen, captured just before the overlay opened.
    Image {
        anchors.fill: parent
        source: root.visible ? "file:///tmp/quickshell-screenshot/" + root.screen.name + ".png" : ""
        fillMode: Image.Stretch
        cache: false
    }

    // Full dim, shown until a selection has real size.
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.45)
        visible: root.selW === 0 || root.selH === 0
    }

    // Dim everything outside the selection, leaving a clear "hole".
    Item {
        anchors.fill: parent
        visible: root.selW > 0 && root.selH > 0

        Rectangle {
            color: Qt.rgba(0, 0, 0, 0.45)
            x: 0; y: 0
            width: parent.width
            height: root.selY
        }
        Rectangle {
            color: Qt.rgba(0, 0, 0, 0.45)
            x: 0; y: root.selY + root.selH
            width: parent.width
            height: parent.height - root.selY - root.selH
        }
        Rectangle {
            color: Qt.rgba(0, 0, 0, 0.45)
            x: 0; y: root.selY
            width: root.selX
            height: root.selH
        }
        Rectangle {
            color: Qt.rgba(0, 0, 0, 0.45)
            x: root.selX + root.selW; y: root.selY
            width: parent.width - root.selX - root.selW
            height: root.selH
        }

        Rectangle {
            x: root.selX; y: root.selY
            width: root.selW; height: root.selH
            color: "transparent"
            border.color: "#33ccff"
            border.width: 2
        }

        Rectangle {
            x: root.selX
            y: Math.max(0, root.selY - height - 4)
            width: dimText.implicitWidth + 12
            height: dimText.implicitHeight + 6
            radius: 4
            color: "#11111b"

            Text {
                id: dimText
                anchors.centerIn: parent
                text: Math.round(root.selW) + " x " + Math.round(root.selH)
                color: "#cdd6f4"
                font.pixelSize: 12
            }
        }
    }

    Item {
        id: focusItem
        anchors.fill: parent
        focus: true
        Keys.onEscapePressed: root.done()

        MouseArea {
            id: dragArea
            anchors.fill: parent
            cursorShape: Qt.CrossCursor
            property real startX: 0
            property real startY: 0

            onPressed: mouse => {
                dragArea.startX = mouse.x
                dragArea.startY = mouse.y
                root.selX = mouse.x
                root.selY = mouse.y
                root.selW = 0
                root.selH = 0
                root.selecting = true
            }

            onPositionChanged: mouse => {
                if (!root.selecting) return
                root.selX = Math.min(dragArea.startX, mouse.x)
                root.selY = Math.min(dragArea.startY, mouse.y)
                root.selW = Math.abs(mouse.x - dragArea.startX)
                root.selH = Math.abs(mouse.y - dragArea.startY)
            }

            onReleased: {
                root.selecting = false
                if (root.selW < 4 || root.selH < 4) {
                    root.done()
                    return
                }
                captureProc.geometry =
                    Math.round(root.screen.x + root.selX) + "," + Math.round(root.screen.y + root.selY) +
                    " " + Math.round(root.selW) + "x" + Math.round(root.selH)
                captureProc.running = true
            }
        }
    }

    Process {
        id: captureProc
        property string geometry: ""
        command: ["sh", "-c",
            "dir=\"$HOME/Pictures/Screenshots\"; mkdir -p \"$dir\"; " +
            "f=\"$dir/screenshot_$(date +%Y-%m-%d_%H-%M-%S).png\"; " +
            "grim -g \"$1\" \"$f\" && wl-copy < \"$f\" && " +
            "notify-send -i \"$f\" 'Screenshot saved' \"$f\"",
            "sh", captureProc.geometry]
        onRunningChanged: if (!running) root.done()
    }
}
