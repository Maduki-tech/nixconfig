import Quickshell
import Quickshell.Io

ShellRoot {
    property bool launcherOpen: false
    property bool btMenuOpen: false
    property bool batMenuOpen: false

    IpcHandler {
        target: "launcher"
        function toggle() { launcherOpen = !launcherOpen }
        function open()   { launcherOpen = true }
        function close()  { launcherOpen = false }
    }

    Variants {
        model: Quickshell.screens

        Bar {
            required property var modelData
            screen: modelData
            onLauncherToggled: launcherOpen = !launcherOpen
            onBtToggled: btMenuOpen = !btMenuOpen
            onBatToggled: batMenuOpen = !batMenuOpen
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

    Notifications {}
}
