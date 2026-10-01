import Quickshell
import Quickshell.Io
import QtQuick
import ".."

Item {
    id: root
    visible: available
    implicitWidth: 24
    implicitHeight: 24

    property bool available: false
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
                    root.available = true
                    root.currentProfile = p
                } else {
                    root.available = false
                }
            }
        }
    }

    Process {
        id: profileSetter
        property string targetProfile: ""
        command: ["powerprofilesctl", "set", targetProfile]

        onExited: exitCode => {
            if (exitCode === 0) {
                root.currentProfile = targetProfile
                Quickshell.execDetached([
                    "notify-send",
                    "-i",
                    "preferences-system-power",
                    "-u",
                    "low",
                    "Power Profile",
                    "Profile set to: " + targetProfile
                ])
            }
            if (!profileChecker.running) {
                profileChecker.running = true
            }
        }
    }

    Timer {
        interval: 10000
        running: root.available
        repeat: true
        onTriggered: {
            if (!profileChecker.running && !profileSetter.running) {
                profileChecker.running = true
            }
        }
    }

    function cycleProfile() {
        if (profileSetter.running) return

        let next = "balanced"
        if (root.currentProfile === "power-saver") {
            next = "balanced"
        } else if (root.currentProfile === "balanced") {
            next = "performance"
        } else if (root.currentProfile === "performance") {
            next = "power-saver"
        }

        profileSetter.targetProfile = next
        profileSetter.running = true
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

    Rectangle {
        anchors.fill: parent
        radius: Theme.radius
        color: profileMouse.containsMouse ? Theme.bg1 : "transparent"
    }

    Text {
        anchors.centerIn: parent
        text: root.icon
        font.family: Theme.fontMono
        font.pixelSize: Theme.fontSizeNormal
        color: profileMouse.containsMouse ? Theme.fg0 : root.profileColor
    }

    MouseArea {
        id: profileMouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.cycleProfile()
    }
}
