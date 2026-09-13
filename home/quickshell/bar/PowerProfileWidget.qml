import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import ".."

RowLayout {
    id: root
    visible: hasDaemon
    spacing: 4

    property bool hasDaemon: false
    property string currentProfile: "balanced"

    Process {
        id: profileChecker
        command: [
            "sh",
            "-c",
            "command -v powerprofilesctl >/dev/null 2>&1 && powerprofilesctl get 2>/dev/null || echo 'none'"
        ]
        running: true
        stdout: SplitParser {
            onRead: data => {
                let p = data.trim()
                if (p === "performance" || p === "balanced" || p === "power-saver") {
                    root.hasDaemon = true
                    root.currentProfile = p
                } else {
                    root.hasDaemon = false
                }
            }
        }
    }

    Timer {
        interval: 4000
        running: true
        repeat: true
        onTriggered: profileChecker.running = true
    }

    function cycleProfile() {
        let next = "balanced"
        if (root.currentProfile === "power-saver") {
            next = "balanced"
        } else if (root.currentProfile === "balanced") {
            next = "performance"
        } else if (root.currentProfile === "performance") {
            next = "power-saver"
        }

        root.currentProfile = next
        Quickshell.execDetached([
            "sh",
            "-c",
            "powerprofilesctl set " + next + " && notify-send -i preferences-system-power 'Power Profile' 'Profile set to: " + next + "'"
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

    Text {
        text: root.icon
        font.family: Theme.fontMono
        font.pixelSize: Theme.fontSizeNormal
        color: profileMouse.containsMouse ? Theme.fg0 : root.profileColor

        MouseArea {
            id: profileMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.cycleProfile()
        }
    }
}
