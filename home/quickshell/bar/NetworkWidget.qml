import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import ".."

Item {
    id: root
    implicitWidth: netRow.implicitWidth + 8
    implicitHeight: 24

    property string iface: ""
    property bool isConnected: iface !== "" && iface !== "none"
    property bool isWifi: isConnected && iface.startsWith("w")
    property bool isEthernet: isConnected && iface.startsWith("e")

    Process {
        id: netProc
        command: ["sh", "-c", "ip route get 1.1.1.1 2>/dev/null | grep -oP 'dev \\K\\S+' || echo 'none'"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                root.iface = data.trim()
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: netProc.running = true
    }

    readonly property string icon: {
        if (isWifi) return ""
        if (isEthernet) return "󰈀"
        return "󰤮"
    }

    readonly property color netColor: isConnected ? Theme.blue : Theme.red

    NetworkPopup {
        id: netPopup
        anchor.item: root
        visible: false
    }

    Rectangle {
        anchors.fill: parent
        radius: Theme.radius
        color: (mouseArea.containsMouse || netPopup.visible) ? Theme.bg1 : "transparent"
    }

    RowLayout {
        id: netRow
        anchors.centerIn: parent
        spacing: 4

        Text {
            text: root.icon
            font.family: Theme.fontMono
            font.pixelSize: Theme.fontSizeNormal
            color: root.netColor
        }

        Text {
            text: root.isConnected ? root.iface : "Offline"
            font.family: Theme.fontMono
            font.pixelSize: Theme.fontSizeNormal
            color: root.netColor
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
                netPopup.visible = !netPopup.visible
            } else if (mouse.button === Qt.RightButton) {
                Quickshell.execDetached(["nm-connection-editor"])
            }
        }
    }
}
