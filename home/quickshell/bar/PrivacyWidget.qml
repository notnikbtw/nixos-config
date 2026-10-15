import Quickshell
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts
import ".."

Item {
    id: root

    // Client streams that read from a mic or camera, straight from PipeWire (no polling)
    readonly property var streams: Pipewire.nodes.values.filter(n => n.isStream)

    PwObjectTracker {
        objects: root.streams
    }

    function isActive(mediaClass) {
        return root.streams.some(n => n.ready
            && n.properties["media.class"] === mediaClass
            && n.properties["media.name"] !== "Peak detect")
    }

    readonly property bool micActive: isActive("Stream/Input/Audio")
    readonly property bool camActive: isActive("Stream/Input/Video")

    visible: micActive || camActive

    implicitWidth: row.implicitWidth + 12
    implicitHeight: 22

    Rectangle {
        anchors.fill: parent
        radius: Theme.radius
        color: Theme.bg1
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 6

        Text {
            visible: root.camActive
            text: "󰄀"
            font.family: Theme.fontMono
            font.pixelSize: Theme.fontSizeNormal
            color: Theme.fgHigh
        }

        Text {
            visible: root.micActive
            text: "󰍬"
            font.family: Theme.fontMono
            font.pixelSize: Theme.fontSizeNormal
            color: Theme.fgHigh
        }
    }
}
