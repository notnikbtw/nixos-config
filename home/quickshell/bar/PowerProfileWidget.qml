import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower
import QtQuick
import ".."

BarButton {
    id: root
    visible: available
    minWidth: 24

    property bool available: false

    Process {
        command: ["sh", "-c", "command -v powerprofilesctl >/dev/null 2>&1 && powerprofilesctl get >/dev/null 2>&1 && echo yes || echo no"]
        running: true
        stdout: SplitParser {
            onRead: data => root.available = (data.trim() === "yes")
        }
    }

    readonly property int profile: PowerProfiles.profile
    readonly property string currentProfile: {
        if (profile === PowerProfile.Performance) return "performance"
        if (profile === PowerProfile.PowerSaver) return "power-saver"
        return "balanced"
    }

    function cycleProfile() {
        let next = PowerProfile.Balanced
        let name = "balanced"
        if (profile === PowerProfile.PowerSaver) {
            next = PowerProfile.Balanced
            name = "balanced"
        } else if (profile === PowerProfile.Balanced) {
            if (PowerProfiles.hasPerformanceProfile) {
                next = PowerProfile.Performance
                name = "performance"
            } else {
                next = PowerProfile.PowerSaver
                name = "power-saver"
            }
        } else {
            next = PowerProfile.PowerSaver
            name = "power-saver"
        }

        PowerProfiles.profile = next
        Quickshell.execDetached([
            "notify-send", "-i", "preferences-system-power", "-u", "low",
            "Power Profile", "Profile set to: " + name
        ])
    }

    readonly property string icon: {
        if (currentProfile === "performance") return ""
        if (currentProfile === "power-saver") return ""
        return ""
    }

    readonly property color profileColor: {
        if (currentProfile === "performance") return Theme.yellow
        if (currentProfile === "power-saver") return Theme.green
        return Theme.aqua
    }

    onClicked: root.cycleProfile()

    Text {
        text: root.icon
        font.family: Theme.fontMono
        font.pixelSize: Theme.fontSizeNormal
        color: root.containsMouse ? Theme.fg0 : root.profileColor
    }
}
