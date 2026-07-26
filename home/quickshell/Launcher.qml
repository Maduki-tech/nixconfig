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

    property var allApps: []
    property var filteredApps: {
        const q = searchField.text.trim().toLowerCase()
        if (q === "") return allApps.slice(0, 12)
        return allApps
            .filter(a => a.name.toLowerCase().includes(q))
            .slice(0, 12)
    }

    function launch(appId) {
        launchProc.appId = appId
        launchProc.running = true
        close()
    }

    Process {
        id: appListProc
        command: ["sh", "-c",
            "find /run/current-system/sw/share/applications " +
            "/etc/profiles/per-user/maduki/share/applications " +
            "$HOME/.local/share/applications -name '*.desktop' 2>/dev/null | " +
            "sort -u | while IFS= read -r f; do " +
            "  name=$(awk -F= '/^\\[Desktop Entry\\]/{s=1} s && /^Name=/{print substr($0,6); exit}' \"$f\" 2>/dev/null); " +
            "  nd=$(grep -c '^NoDisplay=true' \"$f\" 2>/dev/null); " +
            "  id=$(basename \"${f%.desktop}\"); " +
            "  [ -n \"$name\" ] && [ \"$nd\" = \"0\" ] && printf '%s|%s\\n' \"$name\" \"$id\"; " +
            "done | sort"]
        running: true
        stdout: SplitParser {
            splitMarker: "\n"
            onRead: data => {
                const parts = data.split("|")
                if (parts.length >= 2) {
                    root.allApps = [...root.allApps, {
                        name: parts[0],
                        appId: parts.slice(1).join("|")
                    }]
                }
            }
        }
    }

    Process {
        id: launchProc
        property string appId: ""
        command: ["gtk-launch", launchProc.appId]
    }

    onVisibleChanged: {
        if (visible) {
            searchField.text = ""
            searchField.forceActiveFocus()
        }
    }

    // Dim overlay — click outside to close
    MouseArea {
        anchors.fill: parent
        onClicked: close()

        // Launcher card
        Rectangle {
            anchors.centerIn: parent
            width: 580
            height: Math.min(540, parent.height - 80)
            radius: 12
            color: "#11111b"
            border.color: "#33ccff"
            border.width: 1

            // Block outer MouseArea
            MouseArea { anchors.fill: parent }

            ColumnLayout {
                anchors {
                    fill: parent
                    margins: 16
                }
                spacing: 12

                // Header
                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "Launch App"
                    color: "#33ccff"
                    font.pixelSize: 16
                    font.bold: true
                }

                // Search field
                Rectangle {
                    Layout.fillWidth: true
                    height: 40
                    radius: 8
                    color: "#1e1e2e"
                    border.color: searchField.activeFocus ? "#33ccff" : "#313244"
                    border.width: 1

                    Behavior on border.color { ColorAnimation { duration: 100 } }

                    TextInput {
                        id: searchField
                        anchors {
                            fill: parent
                            leftMargin: 12
                            rightMargin: 12
                        }
                        verticalAlignment: TextInput.AlignVCenter
                        color: "#cdd6f4"
                        font.pixelSize: 14
                        selectionColor: "#33ccff"
                        selectedTextColor: "#11111b"

                        Keys.onReturnPressed: {
                            if (root.filteredApps.length > 0)
                                root.launch(root.filteredApps[appList.currentIndex]?.appId ?? "")
                        }
                        Keys.onDownPressed: appList.incrementCurrentIndex()
                        Keys.onUpPressed: appList.decrementCurrentIndex()
                        Keys.onEscapePressed: root.close()
                    }

                    Text {
                        anchors { fill: parent; leftMargin: 12 }
                        verticalAlignment: Text.AlignVCenter
                        text: "Search applications..."
                        color: "#6c7086"
                        font.pixelSize: 14
                        visible: searchField.text === ""
                    }
                }

                // App list
                ListView {
                    id: appList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: root.filteredApps
                    clip: true
                    currentIndex: 0

                    ScrollBar.vertical: ScrollBar {}

                    delegate: Rectangle {
                        id: appItem
                        required property var modelData
                        required property int index

                        width: ListView.view.width
                        height: 44
                        radius: 8
                        color: appItem.ListView.isCurrentItem
                               ? "#1e1e2e"
                               : (appMouse.containsMouse ? "#181825" : "transparent")

                        Behavior on color { ColorAnimation { duration: 80 } }

                        Rectangle {
                            width: 3
                            height: 24
                            anchors { left: parent.left; leftMargin: 4; verticalCenter: parent.verticalCenter }
                            radius: 2
                            color: "#33ccff"
                            visible: appItem.ListView.isCurrentItem
                        }

                        Text {
                            anchors { verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: 16 }
                            text: appItem.modelData.name
                            color: appItem.ListView.isCurrentItem ? "#cdd6f4" : "#a6adc8"
                            font.pixelSize: 13
                        }

                        MouseArea {
                            id: appMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.launch(appItem.modelData.appId)
                            onEntered: appItem.ListView.view.currentIndex = appItem.index
                        }
                    }
                }
            }
        }
    }
}
