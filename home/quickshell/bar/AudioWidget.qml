import Quickshell
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts
import ".."

Item {
    id: root
    implicitWidth: audioRow.implicitWidth
    implicitHeight: audioRow.implicitHeight

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

    RowLayout {
        id: audioRow
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
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                if (root.sink && root.sink.audio) {
                    root.sink.audio.muted = !root.sink.audio.muted
                }
            } else if (mouse.button === Qt.RightButton) {
                Quickshell.execDetached(["pavucontrol"])
            }
        }
        onWheel: wheel => {
            if (root.sink && root.sink.audio) {
                let step = wheel.angleDelta.y > 0 ? 0.05 : -0.05
                root.sink.audio.volume = Math.max(0.0, Math.min(1.0, root.sink.audio.volume + step))
            }
        }
    }
}
