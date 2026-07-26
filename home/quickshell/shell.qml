import Quickshell
import Quickshell.Io

ShellRoot {
    property bool launcherOpen: false
    property bool btMenuOpen: false

    IpcHandler {
        target: "launcher"
        function toggle() { launcherOpen = !launcherOpen }
        function open()   { launcherOpen = true }
        function close()  { launcherOpen = false }
    }

    Bar {
        onLauncherToggled: launcherOpen = !launcherOpen
        onBtToggled: btMenuOpen = !btMenuOpen
    }

    Launcher {
        visible: launcherOpen
        onClose: launcherOpen = false
    }

    BluetoothMenu {
        visible: btMenuOpen
        onClose: btMenuOpen = false
    }

    Notifications {}
}
