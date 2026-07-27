import Quickshell
import Quickshell.Io

ShellRoot {
    property bool launcherOpen: false
    property bool btMenuOpen: false
    property bool batMenuOpen: false
    property bool netMenuOpen: false
    property bool wallpaperMenuOpen: false
    property bool screenshotActive: false

    IpcHandler {
        target: "launcher"
        function toggle() { launcherOpen = !launcherOpen }
        function open()   { launcherOpen = true }
        function close()  { launcherOpen = false }
    }

    IpcHandler {
        target: "wallpaper"
        function toggle() { wallpaperMenuOpen = !wallpaperMenuOpen }
        function open()   { wallpaperMenuOpen = true }
        function close()  { wallpaperMenuOpen = false }
    }

    IpcHandler {
        target: "screenshot"
        function area() {
            if (screenshotActive) return
            freezeProc.command = ["sh", "-c",
                "mkdir -p /tmp/quickshell-screenshot; " +
                "for o in \"$@\"; do grim -o \"$o\" \"/tmp/quickshell-screenshot/$o.png\"; done",
                "sh"].concat(Quickshell.screens.map(s => s.name))
            freezeProc.running = true
        }
    }

    Process {
        id: freezeProc
        onRunningChanged: if (!running) screenshotActive = true
    }

    Variants {
        model: Quickshell.screens

        Bar {
            required property var modelData
            screen: modelData
            onLauncherToggled: launcherOpen = !launcherOpen
            onBtToggled: btMenuOpen = !btMenuOpen
            onBatToggled: batMenuOpen = !batMenuOpen
            onNetToggled: netMenuOpen = !netMenuOpen
            onWallpaperToggled: wallpaperMenuOpen = !wallpaperMenuOpen
        }
    }

    Variants {
        model: Quickshell.screens

        Screenshot {
            required property var modelData
            screen: modelData
            visible: screenshotActive
            onDone: screenshotActive = false
        }
    }

    Launcher {
        visible: launcherOpen
        onClose: launcherOpen = false
    }

    BluetoothMenu {
        visible: btMenuOpen
        onClose: btMenuOpen = false
    }

    BatteryMenu {
        visible: batMenuOpen
        onClose: batMenuOpen = false
    }

    NetworkMenu {
        visible: netMenuOpen
        onClose: netMenuOpen = false
    }

    WallpaperMenu {
        visible: wallpaperMenuOpen
        onClose: wallpaperMenuOpen = false
    }

    Notifications {}
}
