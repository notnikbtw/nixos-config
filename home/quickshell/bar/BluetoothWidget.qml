import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import ".."

Item {
    id: root
    implicitWidth: btRow.implicitWidth + 8
    implicitHeight: 24

    property bool powered: false
    property int connectedCount: 0

    Process {
        id: btStatusProc
        command: ["sh", "-c", "if bluetoothctl show 2>/dev/null | grep -q 'Powered: yes'; then c=$(bluetoothctl devices Connected 2>/dev/null | wc -l); echo on:$c; else echo off:0; fi"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                let parts = data.trim().split(":")
                root.powered = (parts[0] === "on")
                root.connectedCount = parseInt(parts[1]) || 0
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: btStatusProc.running = true
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

    Rectangle {
        anchors.fill: parent
        radius: Theme.radius
        color: mouseArea.containsMouse ? Theme.bg1 : "transparent"
    }

    RowLayout {
        id: btRow
        anchors.centerIn: parent
        spacing: 4

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

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                Quickshell.execDetached(["sh", "-c", "if bluetoothctl show | grep -q 'Powered: yes'; then bluetoothctl power off; else bluetoothctl power on; fi"])
                btStatusProc.running = true
            } else if (mouse.button === Qt.RightButton) {
                Quickshell.execDetached(["blueman-manager"])
            }
        }
    }
}
