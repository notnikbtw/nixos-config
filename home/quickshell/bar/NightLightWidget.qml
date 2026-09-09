import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import ".."

Item {
    id: root

    implicitWidth: row.implicitWidth + 8
    implicitHeight: 24

    property bool isActive: false

    property int temperature: 4800 

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: checkProc.running = true
    }

    Process {
        id: checkProc
        command: ["sh", "-c", "pgrep -x hyprsunset >/dev/null && echo 'on' || echo 'off'"]
        stdout: SplitParser {
            onRead: data => {
                root.isActive = (data.trim() === "on")
            }
        }
    }

    function toggle() {
        if (root.isActive) {
            Quickshell.execDetached(["pkill", "-x", "hyprsunset"])
            root.isActive = false
        } else {
            Quickshell.execDetached(["hyprsunset", "-t", root.temperature.toString()])
            root.isActive = true
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: Theme.radius
        color: mouseArea.containsMouse ? Theme.bg1 : "transparent"
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 4

        Text {
            text: root.isActive ? "󰛨" : "󰛩"
            font.family: Theme.fontMono
            font.pixelSize: Theme.fontSizeNormal
            color: root.isActive ? Theme.fgHigh : Theme.fgMuted
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.toggle()
    }
}
