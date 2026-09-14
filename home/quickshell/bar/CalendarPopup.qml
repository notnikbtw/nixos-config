import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import ".."

PopupWindow {
    id: calWindow

    property var currentTime: new Date()

    color: "transparent"

    grabFocus: true

    anchor {
        gravity: Edges.Bottom
        edges: Edges.Bottom
    }

    implicitWidth: calFrame.implicitWidth
    implicitHeight: calFrame.implicitHeight + 4

    HyprlandFocusGrab {
        windows: [calWindow]
        active: calWindow.visible
        onCleared: calWindow.visible = false
    }

    Rectangle {
        id: calFrame
        anchors.top: parent.top
        anchors.topMargin: 4
        anchors.horizontalCenter: parent.horizontalCenter

        implicitWidth: 260
        implicitHeight: calLayout.implicitHeight + 24
        radius: Theme.radius
        color: Theme.bg0
        border.width: 1
        border.color: Theme.bg2

        ColumnLayout {
            id: calLayout
            anchors.fill: parent
            anchors.margins: 14
            spacing: 12

            ColumnLayout {
                spacing: 2
                Layout.fillWidth: true

                Text {
                    text: Qt.formatDateTime(calWindow.currentTime, "MMMM yyyy")
                    font.family: Theme.fontMono
                    font.pixelSize: Theme.fontSizeNormal
                    font.bold: true
                    color: Theme.fgHigh
                }

                Text {
                    text: Qt.formatDateTime(calWindow.currentTime, "dddd, d MMMM yyyy")
                    font.family: Theme.fontMono
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.fgDim
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Theme.bg2
            }

            GridLayout {
                columns: 7
                rowSpacing: 6
                columnSpacing: 6
                Layout.alignment: Qt.AlignHCenter

                Repeater {
                    model: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
                    delegate: Text {
                        text: modelData
                        font.family: Theme.fontMono
                        font.pixelSize: Theme.fontSizeSmall
                        font.bold: true
                        color: Theme.fgMuted
                        horizontalAlignment: Text.AlignHCenter
                        Layout.preferredWidth: 24
                    }
                }
            }

            GridLayout {
                id: daysGrid
                columns: 7
                rowSpacing: 4
                columnSpacing: 6
                Layout.alignment: Qt.AlignHCenter

                readonly property int year: calWindow.currentTime.getFullYear()
                readonly property int month: calWindow.currentTime.getMonth()
                readonly property int today: calWindow.currentTime.getDate()

                readonly property int firstDayIndex: {
                    let d = new Date(year, month, 1).getDay()
                    return (d === 0) ? 6 : d - 1
                }
                readonly property int daysInMonth: new Date(year, month + 1, 0).getDate()

                Repeater {
                    model: daysGrid.firstDayIndex + daysGrid.daysInMonth

                    delegate: Rectangle {
                        required property int index
                        readonly property int dayNum: index - daysGrid.firstDayIndex + 1
                        readonly property bool isDay: index >= daysGrid.firstDayIndex
                        readonly property bool isToday: isDay && dayNum === daysGrid.today

                        Layout.preferredWidth: 24
                        Layout.preferredHeight: 24
                        radius: Theme.radius
                        color: isToday ? Theme.fgHigh : "transparent"

                        Text {
                            anchors.centerIn: parent
                            visible: parent.isDay
                            text: parent.dayNum > 0 ? parent.dayNum : ""
                            font.family: Theme.fontMono
                            font.pixelSize: Theme.fontSizeSmall
                            font.bold: parent.isToday
                            color: parent.isToday ? Theme.bg0 : Theme.fgText
                        }
                    }
                }
            }
        }
    }
}
