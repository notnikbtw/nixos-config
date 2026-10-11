import Quickshell
import QtQuick
import ".."

BarButton {
    id: root

    active: calendarPopup.visible

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    readonly property string timeStr: Qt.formatDateTime(clock.date, "HH:mm")

    CalendarPopup {
        id: calendarPopup
        anchor.item: root
        visible: false
    }

    onClicked: {
        calendarPopup.currentTime = clock.date
        calendarPopup.visible = !calendarPopup.visible
    }

    Text {
        text: root.timeStr
        font.family: Theme.fontMono
        font.pixelSize: Theme.fontSizeNormal
        font.bold: true
        color: Theme.fgHigh
    }
}
