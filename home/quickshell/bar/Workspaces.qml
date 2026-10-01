import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import ".."

RowLayout {
    id: root
    spacing: 4

    function wsHasWindows(ws) {
        if (!ws) return false
        return ws.windows > 0
            || (ws.toplevels && ws.toplevels.values.length > 0)
            || (ws.lastIpcObject && ws.lastIpcObject.windows > 0)
    }

    readonly property var workspaceIds: {
        let ids = [1, 2, 3, 4, 5]
        let focusedId = (Hyprland.focusedWorkspace && Hyprland.focusedWorkspace.id > 0)
            ? Hyprland.focusedWorkspace.id
            : -1

        if (Hyprland.workspaces && Hyprland.workspaces.values) {
            for (let i = 0; i < Hyprland.workspaces.values.length; i++) {
                let ws = Hyprland.workspaces.values[i]
                if (!ws || ws.id <= 5) continue

                if (root.wsHasWindows(ws) || ws.id === focusedId) {
                    ids.push(ws.id)
                }
            }
        }

        return ids.sort((a, b) => a - b)
    }

    Repeater {
        model: root.workspaceIds

        delegate: Rectangle {
            id: wsBtn
            required property int modelData
            readonly property int wsId: modelData
            readonly property bool isFocused: Hyprland.focusedWorkspace && Hyprland.focusedWorkspace.id === wsId
            readonly property bool hasWindows: {
                if (!Hyprland.workspaces || !Hyprland.workspaces.values) return false
                let ws = Hyprland.workspaces.values.find(w => w.id === wsId)
                return root.wsHasWindows(ws)
            }

            implicitWidth: 22
            implicitHeight: 22
            radius: Theme.radius
            color: hoverArea.containsMouse ? Theme.bg1 : "transparent"

            Item {
                anchors.centerIn: parent

                Text {
                    anchors.centerIn: parent
                    text: "󰊠"
                    font.family: Theme.fontMono
                    font.pixelSize: Theme.fontSizeNormal
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
