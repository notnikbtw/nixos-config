import Quickshell
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts
import ".."

RowLayout {
    id: root
    spacing: 6

    Repeater {
        model: SystemTray.items.values

        delegate: Item {
            id: trayItem
            required property var modelData

            implicitWidth: 18
            implicitHeight: 18

            QsMenuAnchor {
                id: menuAnchor
                anchor.item: trayItem
                menu: trayItem.modelData.menu
            }

            Image {
                anchors.fill: parent
                source: trayItem.modelData.icon
                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                cursorShape: Qt.PointingHandCursor
                onClicked: mouse => {
                    if (mouse.button === Qt.LeftButton) {
                        if (trayItem.modelData.onlyMenu) {
                            menuAnchor.open()
                        } else {
                            trayItem.modelData.activate()
                        }
                    } else if (mouse.button === Qt.RightButton) {
                        if (trayItem.modelData.hasMenu) {
                            menuAnchor.open()
                        }
                    }
                }
            }
        }
    }
}
