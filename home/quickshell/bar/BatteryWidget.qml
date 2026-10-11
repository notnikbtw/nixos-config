import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts
import ".."

RowLayout {
    id: root

    readonly property var device: UPower.displayDevice

    visible: device !== null && device.isLaptopBattery && device.isPresent
    spacing: 4

    // energy/energyCapacity does not depend on whether `percentage` is 0-1 or 0-100
    readonly property int capacity: {
        if (!device) return 0
        if (device.energyCapacity > 0)
            return Math.max(0, Math.min(100, Math.round(device.energy / device.energyCapacity * 100)))
        return Math.round(device.percentage <= 1 ? device.percentage * 100 : device.percentage)
    }

    readonly property bool isCharging: device
        && (device.state === UPowerDeviceState.Charging
            || device.state === UPowerDeviceState.FullyCharged)

    readonly property color batColor: {
        if (isCharging) return Theme.aqua
        if (capacity <= 15) return Theme.red
        if (capacity <= 30) return Theme.yellow
        return Theme.green
    }

    readonly property string batIcon: {
        if (isCharging) return "󱐋"
        if (capacity >= 90) return "󰁹"
        if (capacity >= 75) return "󰂂"
        if (capacity >= 50) return "󰂀"
        if (capacity >= 35) return "󰁾"
        if (capacity >= 20) return "󰁼"
        if (capacity >= 10) return "󰁺"
        return "󰂎"
    }

    Text {
        text: root.batIcon
        font.family: Theme.fontMono
        font.pixelSize: Theme.fontSizeNormal
        color: root.batColor
    }

    Text {
        text: root.capacity + "%"
        font.family: Theme.fontMono
        font.pixelSize: Theme.fontSizeNormal
        color: root.batColor
    }
}
