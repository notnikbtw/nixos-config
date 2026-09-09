import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import ".."

RowLayout {
    id: root
    spacing: 4

    Repeater {
        model: 5

        delegate: Rectangle {
            id: wsBtn
            required property int index
            readonly property int wsId: index + 1
            readonly property bool isFocused: Hyprland.focusedWorkspace && Hyprland.focusedWorkspace.id === wsId
            readonly property bool hasWindows: {
                if (!Hyprland.workspaces) return false
                let ws = Hyprland.workspaces.values.find(w => w.id === wsId)
                return ws ? (ws.windows > 0 || (ws.toplevels && ws.toplevels.values.length > 0) || (ws.lastIpcObject && ws.lastIpcObject.windows > 0)) : false
            }

            implicitWidth: 22
            implicitHeight: 22
            radius: Theme.radius
            color: hoverArea.containsMouse ? Theme.bg1 : "transparent"

            Item {
                anchors.centerIn: parent

                Rectangle {
                    anchors.centerIn: parent
                    width: 8
                    height: 8
                    radius: 1
                    color: Theme.fgHigh
                    visible: wsBtn.isFocused
                }

                Text {
                    anchors.centerIn: parent
                    text: wsBtn.wsId
                    font.family: Theme.fontMono
                    font.pixelSize: Theme.fontSizeSmall
                    font.bold: wsBtn.hasWindows
                    color: wsBtn.hasWindows ? Theme.fgHigh : Theme.fgMuted
                    visible: !wsBtn.isFocused
                }
            }

            MouseArea {
                id: hoverArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    Hyprland.dispatch("hl.dsp.focus({ workspace = " + wsBtn.wsId + " })")
                }
                onWheel: wheel => {
                    if (wheel.angleDelta.y > 0) {
                        Hyprland.dispatch("hl.dsp.focus({ workspace = 'e-1' })")
                    } else if (wheel.angleDelta.y < 0) {
                        Hyprland.dispatch("hl.dsp.focus({ workspace = 'e+1' })")
                    }
                }
            }
        }
    }
}
