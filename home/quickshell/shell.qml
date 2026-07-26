import Quickshell

ShellRoot {
    property bool launcherOpen: false

    Bar {
        onLauncherToggled: launcherOpen = !launcherOpen
    }

    Launcher {
        visible: launcherOpen
        onClose: launcherOpen = false
    }

    Notifications {}
}
