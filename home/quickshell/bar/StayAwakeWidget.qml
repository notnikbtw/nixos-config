import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import ".."

Item {
    id: root

    property bool isActive: false

    implicitWidth: 24
    implicitHeight: 24

    Timer {
        interval: 3000
        running: true
        repeat: true
        triggeredOnStart: true
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

    Rectangle {
        anchors.fill: parent
        radius: Theme.radius
        color: mouseArea.containsMouse ? Theme.bg1 : "transparent"
    }

    Text {
        anchors.centerIn: parent
        text: "󰅶"
        font.family: Theme.fontMono
        font.pixelSize: Theme.fontSizeNormal
        color: root.isActive ? Theme.accent : (mouseArea.containsMouse ? Theme.fgHigh : Theme.fgMuted)
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.toggle()
    }
}
