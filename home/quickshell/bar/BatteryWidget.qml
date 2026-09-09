import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import ".."

RowLayout {
    id: root
    visible: hasBattery
    spacing: 4

    property bool hasBattery: false
    property int capacity: 100
    property string status: "Discharging"

    Process {
        id: batChecker
        command: ["sh", "-c", "for b in /sys/class/power_supply/BAT*; do if [ -f \"$b/capacity\" ]; then echo \"$(cat \"$b/capacity\") $(cat \"$b/status\")\"; exit 0; fi; done; echo 'none'"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                let parts = data.trim().split(/\s+/)
                if (parts.length >= 2 && parts[0] !== "none") {
                    let cap = parseInt(parts[0])
                    if (!isNaN(cap)) {
                        root.hasBattery = true
                        root.capacity = cap
                        root.status = parts[1]
                        return
                    }
                }
                root.hasBattery = false
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: batChecker.running = true
    }

    readonly property bool isCharging: status === "Charging" || status === "Full"
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
