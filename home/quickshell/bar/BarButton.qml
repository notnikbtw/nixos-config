import QtQuick
import QtQuick.Layouts
import ".."

// Hover-highlighted, clickable bar item. Children (usually Text) are laid out
// in a centered row; non-visual children (Timer, Process, ...) are fine too.
Item {
    id: root

    // Keeps the highlight while something belonging to the button is open (e.g. a popup)
    property bool active: false
    property real minWidth: 0
    property real horizontalPadding: 8
    property int acceptedButtons: Qt.LeftButton
    property alias spacing: row.spacing
    readonly property alias containsMouse: mouseArea.containsMouse

    default property alias content: row.data

    signal clicked(var mouse)
    signal scrolled(var wheel)

    implicitWidth: Math.max(minWidth, row.implicitWidth + horizontalPadding)
    implicitHeight: 24

    Rectangle {
        anchors.fill: parent
        radius: Theme.radius
        color: (mouseArea.containsMouse || root.active) ? Theme.bg1 : "transparent"
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 4
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: root.acceptedButtons
        onClicked: mouse => root.clicked(mouse)
        onWheel: wheel => root.scrolled(wheel)
    }
}
