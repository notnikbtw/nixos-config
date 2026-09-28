import Quickshell
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts
import ".."

Item {
    id: root
    implicitWidth: audioRow.implicitWidth + 8
    implicitHeight: 24

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property real volume: sink && sink.audio ? sink.audio.volume : 0
    readonly property bool muted: sink && sink.audio ? sink.audio.muted : false
    readonly property int volPercent: Math.round(volume * 100)

    readonly property string icon: {
        if (muted || volPercent === 0) return "󰝟"
        if (volPercent < 33) return "󰕿"
        if (volPercent < 66) return "󰖀"
        return "󰕾"
    }

    Rectangle {
        anchors.fill: parent
        radius: Theme.radius
        color: mouseArea.containsMouse ? Theme.bg1 : "transparent"
    }

    RowLayout {
        id: audioRow
        anchors.centerIn: parent
        spacing: 4

        Text {
            text: root.icon
            font.family: Theme.fontMono
            font.pixelSize: Theme.fontSizeNormal
            color: root.muted ? Theme.fgMuted : Theme.fgDim
        }

        Text {
            text: root.muted ? "Muted" : (root.volPercent + "%")
            font.family: Theme.fontMono
            font.pixelSize: Theme.fontSizeNormal
            color: root.muted ? Theme.fgMuted : Theme.fgText
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            Quickshell.execDetached(["pavucontrol"])
        }
    }
}
