import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts
import ".."

RowLayout {
    id: root
    spacing: 4

    property bool expanded: false
    readonly property var items: SystemTray.items.values
    readonly property int totalCount: items.length
    readonly property bool needsDrawer: totalCount > 2

    // Drawer toggle button (shown when there are more than 2 items)
    Rectangle {
        visible: root.needsDrawer
        implicitWidth: 16
        implicitHeight: 20
        radius: Theme.radius
        color: drawerMouse.containsMouse ? Theme.bg2 : "transparent"

        Text {
            anchors.centerIn: parent
            text: root.expanded ? "󰅁" : "󰅂"
            font.family: Theme.fontMono
            font.pixelSize: 11
            color: Theme.fgDim
        }

        MouseArea {
            id: drawerMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.expanded = !root.expanded
        }
    }

    Repeater {
        model: root.items

        delegate: Item {
            id: trayItem
            required property var modelData
            required property int index

            // In collapsed mode, only the first 2 items are visible
            visible: !root.needsDrawer || root.expanded || index < 2

            implicitWidth: 20
            implicitHeight: 20

            QsMenuAnchor {
                id: menuAnchor
                anchor.item: trayItem
                menu: trayItem.modelData.menu
            }

            Rectangle {
                anchors.fill: parent
                radius: Theme.radius
                color: itemMouse.containsMouse ? Theme.bg2 : "transparent"
            }

            IconImage {
                anchors.centerIn: parent
                width: 16
                height: 16
                source: trayItem.modelData.icon
            }

            MouseArea {
                id: itemMouse
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                cursorShape: Qt.PointingHandCursor
                onClicked: mouse => {
                    if (mouse.button === Qt.LeftButton) {
                        if (trayItem.modelData.onlyMenu) {
                            menuAnchor.open()
                        } else {
                            trayItem.modelData.activate()
                        }
                    } else if (mouse.button === Qt.MiddleButton) {
                        trayItem.modelData.secondaryActivate()
                    } else if (mouse.button === Qt.RightButton) {
                        if (trayItem.modelData.hasMenu) {
                            menuAnchor.open()
                        }
                    }
                }
                onWheel: wheel => {
                    trayItem.modelData.scroll(wheel.angleDelta.y)
                }
            }
        }
    }
}
