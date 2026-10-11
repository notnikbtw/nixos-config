import Quickshell
import Quickshell.Bluetooth
import QtQuick
import QtQuick.Layouts
import ".."

BarButton {
    id: root

    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property bool powered: adapter !== null && adapter.enabled
    readonly property int connectedCount: {
        if (!Bluetooth.devices) return 0
        return Bluetooth.devices.values.filter(d => d.connected).length
    }

    readonly property string icon: {
        if (!root.powered) return "󰂲"
        if (root.connectedCount > 0) return "󰂱"
        return "󰂯"
    }

    readonly property color btColor: {
        if (!root.powered) return Theme.fgMuted
        if (root.connectedCount > 0) return Theme.accent
        return Theme.blue
    }

    onClicked: Quickshell.execDetached(["blueman-manager"])

    Text {
        text: root.icon
        font.family: Theme.fontMono
        font.pixelSize: Theme.fontSizeNormal
        color: root.btColor
    }

    Text {
        visible: root.connectedCount > 0
        text: root.connectedCount.toString()
        font.family: Theme.fontMono
        font.pixelSize: Theme.fontSizeSmall
        color: root.btColor
    }
}
