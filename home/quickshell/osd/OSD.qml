import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts
import ".."

PanelWindow {
    id: osdWindow

    anchors {
        bottom: true
    }
    margins {
        bottom: 80
    }

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    exclusiveZone: 0
    color: "transparent"

    mask: Region {}

    readonly property bool hasBar: osdType === "volume" || osdType === "brightness"

    visible: false
    implicitWidth: 260
    implicitHeight: hasBar ? 52 : 36

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
    }

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource

    readonly property real sinkVolume: sink && sink.audio ? sink.audio.volume : 0
    readonly property bool sinkMuted: sink && sink.audio ? sink.audio.muted : false
    readonly property bool sourceMuted: source && source.audio ? source.audio.muted : false

    property bool ready: false
    property real lastSinkVolume: -1
    property bool lastSinkMuted: false
    property bool lastSourceMuted: false

    property string osdType: "volume"
    property string osdIcon: "󰕾"
    property string osdTitle: "Volume"
    property string osdValue: "50%"
    property real osdProgress: 0.5
    property color osdColor: Theme.orange

    Timer {
        interval: 1500
        running: true
        onTriggered: {
            osdWindow.lastSinkVolume = osdWindow.sinkVolume
            osdWindow.lastSinkMuted = osdWindow.sinkMuted
            osdWindow.lastSourceMuted = osdWindow.sourceMuted
            osdWindow.ready = true
        }
    }

    onSinkVolumeChanged: {
        if (!ready) return
        if (Math.abs(sinkVolume - lastSinkVolume) > 0.001) {
            lastSinkVolume = sinkVolume
            triggerAudio()
        }
    }

    onSinkMutedChanged: {
        if (!ready) return
        if (sinkMuted !== lastSinkMuted) {
            lastSinkMuted = sinkMuted
            triggerAudio()
        }
    }

    onSourceMutedChanged: {
        if (!ready) return
        if (sourceMuted !== lastSourceMuted) {
            lastSourceMuted = sourceMuted
            triggerMic()
        }
    }

    function volumeIcon(percent) {
        if (percent <= 0) return "󰝟"
        if (percent < 33) return "󰕿"
        if (percent < 66) return "󰖀"
        return "󰕾"
    }

    function brightnessIcon(percent) {
        if (percent < 25) return "󰃞"
        if (percent < 50) return "󰃟"
        if (percent < 75) return "󰃝"
        return "󰃠"
    }

    function show(type, icon, title, value, progress, color) {
        osdType = type
        osdIcon = icon
        osdTitle = title
        osdValue = value
        osdProgress = progress
        osdColor = color
        showOSD()
    }

    function triggerAudio() {
        const vol = Math.max(0, sinkVolume)
        const percent = Math.round(vol * 100)

        if (sinkMuted || percent === 0)
            show("volume", volumeIcon(0), "Volume", "Muted", Math.min(1.0, vol), Theme.fgMuted)
        else
            show("volume", volumeIcon(percent), "Volume", percent + "%", Math.min(1.0, vol), Theme.orange)
    }

    function triggerMic() {
        if (sourceMuted)
            show("mic", "󰍭", "Microphone", "Muted", 0.0, Theme.red)
        else
            show("mic", "󰍬", "Microphone", "Active", 1.0, Theme.green)
    }

    function triggerBrightness(percent) {
        const clamped = Math.max(0, Math.min(100, percent))
        show("brightness", brightnessIcon(clamped), "Brightness", clamped + "%", clamped / 100.0, Theme.yellow)
    }

    function isOn(state) {
        return state === "on" || state === "1" || state === "true"
    }

    function triggerToggle(type, icon, title, state, onColor) {
        const on = isOn(state)
        show(type, icon, title, on ? "ON" : "OFF", on ? 1.0 : 0.0, on ? onColor : Theme.fgMuted)
    }

    function showOSD() {
        fadeOutAnim.stop()
        osdWindow.visible = true
        osdCard.opacity = 1
        popAnim.restart()
        hideTimer.restart()
    }

    SequentialAnimation {
        id: popAnim
        NumberAnimation {
            target: osdCard
            property: "scale"
            from: 0.98
            to: 1.0
            duration: 80
            easing.type: Easing.OutQuad
        }
    }

    Timer {
        id: hideTimer
        interval: 1500
        repeat: false
        onTriggered: {
            fadeOutAnim.start()
        }
    }

    NumberAnimation {
        id: fadeOutAnim
        target: osdCard
        property: "opacity"
        to: 0
        duration: 200
        easing.type: Easing.OutCubic
        onFinished: {
            osdWindow.visible = false
        }
    }

    // Volume and microphone are driven by PipeWire (see the handlers above), so
    // they need no IPC. These are called from the scripts in ../scripts.
    IpcHandler {
        target: "osd"

        function showBrightness(percent: int): void {
            osdWindow.triggerBrightness(percent)
        }

        function showCapsLock(state: string): void {
            osdWindow.triggerToggle("capslock", "󰘲", "Caps Lock", state, Theme.orange)
        }

        function showNumLock(state: string): void {
            osdWindow.triggerToggle("numlock", "󰎠", "Num Lock", state, Theme.orange)
        }

        function showAirplane(state: string): void {
            osdWindow.triggerToggle("airplane", "󰀝", "Airplane Mode", state, Theme.aqua)
        }
    }

    Rectangle {
        id: osdCard
        anchors.fill: parent
        color: Theme.bg0
        border.color: Theme.bg3
        border.width: 1
        radius: Theme.radius
        opacity: 0

        ColumnLayout {
            anchors.fill: parent
            anchors.leftMargin: 14
            anchors.rightMargin: 14
            anchors.topMargin: osdWindow.hasBar ? 9 : 8
            anchors.bottomMargin: osdWindow.hasBar ? 9 : 8
            spacing: osdWindow.hasBar ? 6 : 0

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: osdWindow.osdIcon
                    font.family: Theme.fontMono
                    font.pixelSize: Theme.fontSizeNormal + 2
                    color: osdWindow.osdColor
                    Layout.alignment: Qt.AlignVCenter
                }

                Text {
                    text: osdWindow.osdTitle
                    font.family: Theme.fontMono
                    font.pixelSize: Theme.fontSizeNormal
                    font.bold: true
                    color: Theme.fgHigh
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                }

                Text {
                    text: osdWindow.osdValue
                    font.family: Theme.fontMono
                    font.pixelSize: Theme.fontSizeSmall
                    font.bold: true
                    color: osdWindow.hasBar ? Theme.fgText : osdWindow.osdColor
                    Layout.alignment: Qt.AlignVCenter
                }
            }

            Rectangle {
                visible: osdWindow.hasBar
                Layout.fillWidth: true
                height: 4
                color: Theme.bg2
                radius: Theme.radius

                Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: Math.min(parent.width, Math.max(0, parent.width * osdWindow.osdProgress))
                    color: osdWindow.osdColor
                    radius: Theme.radius

                    Behavior on width {
                        NumberAnimation {
                            duration: 100
                            easing.type: Easing.OutQuad
                        }
                    }
                }
            }
        }
    }
}
