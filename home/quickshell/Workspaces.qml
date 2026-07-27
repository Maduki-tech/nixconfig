pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

RowLayout {
    id: root
    required property var screen

    // hyprsplit gives each monitor its own workspace range (e.g. eDP-1: 1-5,
    // DP-8: 6-10, DP-9: 11-15), all present in the one global Hyprland.workspaces
    // model. Only show/highlight this bar's own slice, matched by output name
    // rather than Hyprland.monitorFor() — that's a one-shot method call, not a
    // bound property, so it never re-resolves if this screen's HyprlandMonitor
    // object gets recreated (e.g. eDP-1 toggling off/on with the lid).
    spacing: 4

    // Must match hyprland.lua's hs.config({ num_workspaces = ... }).
    readonly property int workspacesPerMonitor: 5

    Repeater {
        model: Hyprland.workspaces

        delegate: Item {
            id: wsItem
            required property var modelData

            readonly property bool onThisMonitor: modelData.monitor?.name === root.screen.name
            // "active" is per-monitor (the workspace currently shown on its own
            // output), unlike "focused" which is compositor-wide input focus.
            readonly property bool active: modelData.active
            // Every monitor's range is the same width, so id-within-range maps
            // back to 1..N regardless of which monitor's block it falls in.
            readonly property int localNumber: ((modelData.id - 1) % root.workspacesPerMonitor) + 1

            visible: onThisMonitor
            Layout.preferredWidth: 28
            Layout.preferredHeight: 28

            Rectangle {
                anchors.fill: parent
                radius: 6
                color: wsItem.active ? "#33ccff" : "#1e1e2e"

                Behavior on color { ColorAnimation { duration: 120 } }

                Text {
                    anchors.centerIn: parent
                    text: wsItem.localNumber
                    color: wsItem.active ? "#11111b" : "#cdd6f4"
                    font.pixelSize: 11
                    font.bold: wsItem.active
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                // HyprlandWorkspace.activate() builds the right dispatch string
                // itself (Hyprland here runs native Lua config, where a plain
                // "workspace <id>" string is invalid — it gets executed as raw
                // Lua and needs to be a proper hl.dsp.focus({...}) expression).
                onClicked: wsItem.modelData.activate()
            }
        }
    }
}
