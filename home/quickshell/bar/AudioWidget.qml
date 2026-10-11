import Quickshell
import Quickshell.Services.Pipewire
import QtQuick
import ".."

BarButton {
    id: root

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

    onClicked: Quickshell.execDetached(["pavucontrol"])

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
