import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import ".."

BarButton {
    id: root

    property bool isActive: false
    minWidth: 24

    // Checked at startup, after each toggle
    Component.onCompleted: statusProc.running = true

    Timer {
        interval: 30000
        running: true
        repeat: true
        onTriggered: statusProc.running = true
    }

    Timer {
        id: checkTimer
        interval: 150
        running: false
        repeat: false
        onTriggered: statusProc.running = true
    }

    Process {
        id: statusProc
        command: ["bash", Quickshell.shellDir + "/scripts/stay-awake.sh", "status"]
        stdout: SplitParser {
            onRead: data => {
                root.isActive = (data.trim() === "active")
            }
        }
    }

    function toggle() {
        Quickshell.execDetached(["bash", Quickshell.shellDir + "/scripts/stay-awake.sh", "toggle"])
        checkTimer.restart()
    }

    onClicked: root.toggle()

    Text {
        text: "󰅶"
        font.family: Theme.fontMono
        font.pixelSize: Theme.fontSizeNormal
        color: root.isActive ? Theme.accent : (root.containsMouse ? Theme.fgHigh : Theme.fgMuted)
    }
}
