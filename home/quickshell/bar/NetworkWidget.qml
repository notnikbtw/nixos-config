import Quickshell
import Quickshell.Networking
import QtQuick
import QtQuick.Layouts
import ".."

BarButton {
    id: root

    // Straight from NetworkManager; no polling and no dependence on the default route,
    // so a VPN or Tailscale interface does not confuse the icon.
    readonly property var devices: Networking.devices.values

    readonly property var wiredUp: devices.find(d => d.type === DeviceType.Wired && d.connected) || null
    readonly property var wifiDev: devices.find(d => d.type === DeviceType.Wifi && d.connected) || null
    readonly property var wifiNet: wifiDev ? (wifiDev.networks.values.find(n => n.connected) || null) : null

    readonly property bool isConnected: wiredUp !== null || wifiDev !== null
    // The signal is a 0-1 fraction; accept 0-100 too
    readonly property real signal: wifiNet ? (wifiNet.signalStrength > 1 ? wifiNet.signalStrength / 100 : wifiNet.signalStrength) : 0
    readonly property bool limited: isConnected
        && (Networking.connectivity === NetworkConnectivity.Limited
            || Networking.connectivity === NetworkConnectivity.Portal
            || Networking.connectivity === NetworkConnectivity.None)

    readonly property string icon: {
        // Wired wins over Wi-Fi when both are up
        if (wiredUp) return "󰈀"
        if (wifiDev) {
            if (signal >= 0.75) return "󰤨"
            if (signal >= 0.5) return "󰤥"
            if (signal >= 0.25) return "󰤢"
            return "󰤟"
        }
        return Networking.wifiEnabled ? "󰤮" : "󰤭"
    }

    readonly property color netColor: !isConnected ? Theme.red
                                    : limited ? Theme.yellow
                                    : Theme.blue

    onClicked: Quickshell.execDetached(["nm-connection-editor"])

    Text {
        text: root.icon
        font.family: Theme.fontMono
        font.pixelSize: Theme.fontSizeNormal
        color: root.netColor
    }
}
