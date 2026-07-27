import QtQuick
import Quickshell.Networking

Item {
    id: root
    signal clicked()

    readonly property var wifiDevice: {
        const devs = Networking.devices.values
        for (let i = 0; i < devs.length; i++) {
            if (devs[i].type === DeviceType.Wifi) return devs[i]
        }
        return null
    }

    readonly property var wiredDevice: {
        const devs = Networking.devices.values
        for (let i = 0; i < devs.length; i++) {
            if (devs[i].type === DeviceType.Wired) return devs[i]
        }
        return null
    }

    readonly property var activeWifiNetwork: {
        if (!root.wifiDevice) return null
        const nets = root.wifiDevice.networks.values
        for (let i = 0; i < nets.length; i++) {
            if (nets[i].connected) return nets[i]
        }
        return null
    }

    readonly property bool wiredConnected: root.wiredDevice?.connected ?? false
    readonly property bool wifiConnected: root.wifiDevice?.connected ?? false
    readonly property bool connected: root.wiredConnected || root.wifiConnected

    readonly property string connType: root.wiredConnected ? "ethernet"
                                      : root.wifiConnected  ? "wifi"
                                      :                        "none"

    readonly property string connName: root.wiredConnected ? (root.wiredDevice.network?.name ?? root.wiredDevice.name)
                                      : root.wifiConnected  ? (root.activeWifiNetwork?.name ?? "")
                                      :                        ""

    implicitWidth: row.implicitWidth + 12
    implicitHeight: 28

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 4

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.connType === "wifi"     ? "▲" :
                  root.connType === "ethernet"  ? "⬡" : "○"
            color: root.connected ? "#00ff99" : "#f38ba8"
            font.pixelSize: 13
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.connected ? root.connName : "Offline"
            color: root.connected ? "#cdd6f4" : "#a6adc8"
            font.pixelSize: 11
            elide: Text.ElideRight
            maximumLineCount: 1
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
