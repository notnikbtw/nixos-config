import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import ".."

PopupWindow {
    id: calWindow

    property var currentTime: new Date()

    property int monthOffset: 0
    readonly property var viewDate: new Date(currentTime.getFullYear(), currentTime.getMonth() + monthOffset, 1)

    onVisibleChanged: {
        if (visible) {
            currentTime = new Date()
            monthOffset = 0
        }
    }

    Timer {
        interval: 60000
        running: calWindow.visible
        repeat: true
        onTriggered: calWindow.currentTime = new Date()
    }

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

        MouseArea {
            anchors.fill: parent
            onWheel: wheel => {
                if (wheel.angleDelta.y > 0) calWindow.monthOffset -= 1
                else if (wheel.angleDelta.y < 0) calWindow.monthOffset += 1
            }
        }

        ColumnLayout {
            id: calLayout
            anchors.fill: parent
            anchors.margins: 14
            spacing: 12

            ColumnLayout {
                spacing: 2
                Layout.fillWidth: true

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 4

                    // Month title; click to jump back to the current month
                    Text {
                        text: Qt.formatDateTime(calWindow.viewDate, "MMMM yyyy")
                        font.family: Theme.fontMono
                        font.pixelSize: Theme.fontSizeNormal
                        font.bold: true
                        color: titleMouse.containsMouse && calWindow.monthOffset !== 0 ? Theme.accent : Theme.fgHigh
                        Layout.fillWidth: true

                        MouseArea {
                            id: titleMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: calWindow.monthOffset !== 0 ? Qt.PointingHandCursor : Qt.ArrowCursor
                            onClicked: calWindow.monthOffset = 0
                        }
                    }

                    Repeater {
                        model: [
                            { glyph: "󰅁", step: -1 },
                            { glyph: "󰅂", step: 1 }
                        ]

                        delegate: Rectangle {
                            required property var modelData

                            implicitWidth: 22
                            implicitHeight: 22
                            radius: Theme.radius
                            color: navMouse.containsMouse ? Theme.bg2 : "transparent"

                            Text {
                                anchors.centerIn: parent
                                text: parent.modelData.glyph
                                font.family: Theme.fontMono
                                font.pixelSize: Theme.fontSizeNormal
                                color: navMouse.containsMouse ? Theme.fgHigh : Theme.fgDim
                            }

                            MouseArea {
                                id: navMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: calWindow.monthOffset += parent.modelData.step
                            }
                        }
                    }
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

                readonly property int year: calWindow.viewDate.getFullYear()
                readonly property int month: calWindow.viewDate.getMonth()
                readonly property int today: calWindow.currentTime.getDate()
                readonly property bool showToday: calWindow.monthOffset === 0

                Layout.preferredHeight: 6 * 24 + 5 * rowSpacing
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

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
                        readonly property bool isToday: isDay && daysGrid.showToday && dayNum === daysGrid.today

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
