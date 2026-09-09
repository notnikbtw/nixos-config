import QtQuick
import ".."

Item {
    id: root

    implicitWidth: timeText.implicitWidth + 8
    implicitHeight: 24

    property var currentTime: new Date()
    readonly property string timeStr: Qt.formatDateTime(currentTime, "HH:mm")

    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: root.currentTime = new Date()
    }

    CalendarPopup {
        id: calendarPopup
        anchor.item: root
        visible: false
    }

    Rectangle {
        id: bgBox
        anchors.fill: parent
        radius: Theme.radius
        color: (mouseArea.containsMouse || calendarPopup.visible) ? Theme.bg1 : "transparent"
    }

    Text {
        id: timeText
        anchors.centerIn: parent
        text: root.timeStr
        font.family: Theme.fontMono
        font.pixelSize: Theme.fontSizeNormal
        font.bold: true
        color: Theme.fgHigh
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            root.currentTime = new Date()
            calendarPopup.currentTime = new Date()
            calendarPopup.visible = !calendarPopup.visible
        }
    }
}
