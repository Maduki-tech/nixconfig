import QtQuick
import QtQuick.Layouts
import Quickshell

PanelWindow {
    id: bar
    signal launcherToggled()
    signal btToggled()

    anchors {
        top: true
        left: true
        right: true
    }
    exclusiveZone: height
    implicitHeight: 40
    color: "transparent"

    // Background
    Rectangle {
        anchors.fill: parent
        color: "#11111b"

        // Bottom accent line
        Rectangle {
            anchors { bottom: parent.bottom; left: parent.left; right: parent.right }
            height: 1
            color: "#33ccff"
            opacity: 0.25
        }
    }

    // Left: launcher button + workspaces
    RowLayout {
        id: leftSection
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
            leftMargin: 12
        }
        spacing: 8

        // Launcher toggle button
        Rectangle {
            id: launcherBtn
            width: 30
            height: 30
            radius: 8
            color: launcherHover.containsMouse ? "#33ccff" : "#1e1e2e"

            Behavior on color { ColorAnimation { duration: 100 } }

            Text {
                anchors.centerIn: parent
                text: "⊞"
                color: launcherHover.containsMouse ? "#11111b" : "#cdd6f4"
                font.pixelSize: 16
            }

            MouseArea {
                id: launcherHover
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: bar.launcherToggled()
            }
        }

        Workspaces {}
    }

    // Center: clock
    Clock {
        anchors.centerIn: parent
    }

    // Right: system indicators
    RowLayout {
        id: rightSection
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            rightMargin: 12
        }
        spacing: 4

        Brightness {}

        Rectangle { width: 1; height: 20; color: "#313244" }

        Audio {}

        Rectangle { width: 1; height: 20; color: "#313244" }

        Network {}

        Rectangle { width: 1; height: 20; color: "#313244" }

        Bluetooth {
            onClicked: bar.btToggled()
        }

        Rectangle { width: 1; height: 20; color: "#313244" }

        Tray {}
    }
}
