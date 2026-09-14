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

    visible: false
    implicitWidth: 260
    implicitHeight: 52

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

    function triggerAudio() {
        osdType = "volume"
        let vol = Math.max(0, sinkVolume)
        let percent = Math.round(vol * 100)
        osdProgress = Math.min(1.0, vol)

        if (sinkMuted || percent === 0) {
            osdIcon = "󰝟"
            osdTitle = "Volume"
            osdValue = "Muted"
            osdColor = Theme.fgMuted
        } else {
            if (percent < 33) osdIcon = "󰕿"
            else if (percent < 66) osdIcon = "󰖀"
            else osdIcon = "󰕾"

            osdTitle = "Volume"
            osdValue = percent + "%"
            osdColor = Theme.orange
        }
        showOSD()
    }

    function triggerMicManual(isMuted: bool) {
        osdType = "mic"
        if (isMuted) {
            osdIcon = "󰍭"
            osdTitle = "Microphone"
            osdValue = "Muted"
            osdProgress = 0.0
            osdColor = Theme.red
        } else {
            osdIcon = "󰍬"
            osdTitle = "Microphone"
            osdValue = "Active"
            osdProgress = 1.0
            osdColor = Theme.green
        }
        showOSD()
    }

    function triggerMic() {
        triggerMicManual(sourceMuted)
    }

    function triggerBrightness(percent: int) {
        osdType = "brightness"
        let clamped = Math.max(0, Math.min(100, percent))
        osdProgress = clamped / 100.0
        osdValue = clamped + "%"
        osdTitle = "Brightness"
        osdColor = Theme.yellow

        if (clamped < 25) osdIcon = "󰃞"
        else if (clamped < 50) osdIcon = "󰃟"
        else if (clamped < 75) osdIcon = "󰃝"
        else osdIcon = "󰃠"

        showOSD()
    }

    function triggerVolumeManual(percent: int) {
        osdType = "volume"
        let clamped = Math.max(0, percent)
        osdProgress = Math.min(1.0, clamped / 100.0)
        osdTitle = "Volume"
        osdValue = clamped + "%"
        osdColor = Theme.orange

        if (clamped === 0) {
            osdIcon = "󰝟"
        } else if (clamped < 33) {
            osdIcon = "󰕿"
        } else if (clamped < 66) {
            osdIcon = "󰖀"
        } else {
            osdIcon = "󰕾"
        }

        showOSD()
    }

    function triggerCapsLock(state: string) {
        osdType = "capslock"
        let isOn = (state === "on" || state === "1" || state === "true")
        osdTitle = "Caps Lock"
        osdIcon = "󰘲"
        osdValue = isOn ? "ON" : "OFF"
        osdProgress = isOn ? 1.0 : 0.0
        osdColor = isOn ? Theme.orange : Theme.fgMuted
        showOSD()
    }

    function triggerNumLock(state: string) {
        osdType = "numlock"
        let isOn = (state === "on" || state === "1" || state === "true")
        osdTitle = "Num Lock"
        osdIcon = "󰎠"
        osdValue = isOn ? "ON" : "OFF"
        osdProgress = isOn ? 1.0 : 0.0
        osdColor = isOn ? Theme.orange : Theme.fgMuted
        showOSD()
    }

    function showOSD() {
        fadeOutAnim.stop()
        osdWindow.visible = true
        osdCard.opacity = 1
        hideTimer.restart()
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

    IpcHandler {
        target: "osd"

        function showBrightness(percent: int): void {
            osdWindow.triggerBrightness(percent)
        }

        function showVolume(percent: int): void {
            osdWindow.triggerVolumeManual(percent)
        }

        function showCapsLock(state: string): void {
            osdWindow.triggerCapsLock(state)
        }

        function showNumLock(state: string): void {
            osdWindow.triggerNumLock(state)
        }

        function showMic(state: string): void {
            let isMuted = (state === "muted" || state === "1" || state === "true")
            osdWindow.triggerMicManual(isMuted)
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
            anchors.topMargin: 9
            anchors.bottomMargin: 9
            spacing: 6

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
                    color: Theme.fgText
                    Layout.alignment: Qt.AlignVCenter
                }
            }

            Rectangle {
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
