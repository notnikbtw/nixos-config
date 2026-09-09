import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import ".."

Item {
    id: root

    property string screenName: ""
    property bool isRecording: false
    property int elapsedSeconds: 0

    implicitWidth: 24
    implicitHeight: 24

    function formatTime(totalSec) {
        let m = Math.floor(totalSec / 60)
        let s = totalSec % 60
        return (m < 10 ? "0" : "") + m + ":" + (s < 10 ? "0" : "") + s
    }

    function toggleRecording() {
        let mon = root.screenName
        if (!mon && Hyprland.focusedMonitor) {
            mon = Hyprland.focusedMonitor.name
        }
        let scriptPath = Quickshell.shellDir + "/scripts/record-toggle.sh"
        Quickshell.execDetached(["bash", scriptPath, mon || ""])
        checkTimer.restart()
    }

    function openFolder() {
        Quickshell.execDetached(["sh", "-c", "xdg-open ~/Videos/Recordings || thunar ~/Videos/Recordings"])
    }

    Timer {
        id: checkTimer
        interval: 250
        running: false
        repeat: false
        onTriggered: statusChecker.running = true
    }

    Process {
        id: statusChecker
        command: [
            "sh",
            "-c",
            "if pgrep -x wl-screenrec >/dev/null 2>&1 || pgrep -x wf-recorder >/dev/null 2>&1; then echo 'running'; else echo 'stopped'; fi"
        ]
        running: true
        stdout: SplitParser {
            onRead: data => {
                let state = data.trim()
                if (state === "running") {
                    if (!root.isRecording) {
                        root.isRecording = true
                        root.elapsedSeconds = 0
                    }
                } else if (state === "stopped") {
                    root.isRecording = false
                    root.elapsedSeconds = 0
                }
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            statusChecker.running = true
            if (root.isRecording) {
                root.elapsedSeconds++
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: Theme.radius
        color: mouseArea.containsMouse ? Theme.bg1 : "transparent"
    }

    Item {
        anchors.fill: parent

        Rectangle {
            anchors.centerIn: parent
            width: 8
            height: 8
            radius: 4
            color: Theme.red
            visible: root.isRecording
        }

        Text {
            anchors.centerIn: parent
            visible: !root.isRecording
            text: ""
            font.family: Theme.fontMono
            font.pixelSize: Theme.fontSizeNormal
            color: mouseArea.containsMouse ? Theme.orange : Theme.fg2
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                root.toggleRecording()
            } else if (mouse.button === Qt.RightButton) {
                root.openFolder()
            }
        }
    }

    PopupWindow {
        id: tooltipWindow
        visible: root.isRecording && mouseArea.containsMouse
        color: "transparent"

        anchor {
            item: root
            gravity: Edges.Bottom
            edges: Edges.Bottom
        }

        implicitWidth: tipBox.implicitWidth
        implicitHeight: tipBox.implicitHeight + 4

        Rectangle {
            id: tipBox
            anchors.top: parent.top
            anchors.topMargin: 4
            anchors.horizontalCenter: parent.horizontalCenter

            implicitWidth: tipText.implicitWidth + 12
            implicitHeight: tipText.implicitHeight + 6
            color: Theme.bg0
            border.color: Theme.bg2
            border.width: 1
            radius: Theme.radius

            Text {
                id: tipText
                anchors.centerIn: parent
                text: "Rec: " + root.formatTime(root.elapsedSeconds)
                font.family: Theme.fontMono
                font.pixelSize: Theme.fontSizeSmall
                font.bold: true
                color: Theme.red
            }
        }
    }
}
