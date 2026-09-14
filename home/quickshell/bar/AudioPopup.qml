import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Pipewire
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts
import ".."

PopupWindow {
    id: audioWindow

    color: "transparent"
    grabFocus: true

    anchor {
        gravity: Edges.Bottom
        edges: Edges.Bottom
    }

    implicitWidth: audioFrame.implicitWidth
    implicitHeight: audioFrame.implicitHeight + 8

    HyprlandFocusGrab {
        windows: [audioWindow]
        active: audioWindow.visible
        onCleared: audioWindow.visible = false
    }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
    }

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource

    readonly property var sinks: {
        let list = []
        let nodes = Pipewire.nodes ? Pipewire.nodes.values : []
        for (let i = 0; i < nodes.length; i++) {
            let n = nodes[i]
            if (n && n.isSink && !n.isStream) {
                list.push(n)
            }
        }
        return list
    }

    readonly property var appStreams: {
        let list = []
        let nodes = Pipewire.nodes ? Pipewire.nodes.values : []
        for (let i = 0; i < nodes.length; i++) {
            let n = nodes[i]
            if (n && n.isStream && n.audio) {
                list.push(n)
            }
        }
        return list
    }

    readonly property var activePlayer: {
        let players = Mpris.players ? Mpris.players.values : []
        for (let i = 0; i < players.length; i++) {
            if (players[i].playbackState === MprisPlaybackState.Playing) return players[i]
        }
        return players.length > 0 ? players[0] : null
    }

    function playerArtist(player) {
        if (!player) return ""
        if (player.trackArtists && typeof player.trackArtists.join === "function") {
            return player.trackArtists.join(", ")
        }
        if (player.trackArtists) return String(player.trackArtists)
        return player.identity || "Media Player"
    }

    function togglePlay() {
        let p = audioWindow.activePlayer
        if (!p) {
            Quickshell.execDetached(["playerctl", "play-pause"])
            return
        }
        if (typeof p.togglePlaying === "function") {
            p.togglePlaying()
        } else if (typeof p.playPause === "function") {
            p.playPause()
        } else if (p.playbackState === MprisPlaybackState.Playing && typeof p.pause === "function") {
            p.pause()
        } else if (typeof p.play === "function") {
            p.play()
        } else {
            Quickshell.execDetached(["playerctl", "play-pause"])
        }
    }

    function nextTrack() {
        let p = audioWindow.activePlayer
        if (p && typeof p.next === "function") {
            p.next()
        } else {
            Quickshell.execDetached(["playerctl", "next"])
        }
    }

    function previousTrack() {
        let p = audioWindow.activePlayer
        if (p && typeof p.previous === "function") {
            p.previous()
        } else {
            Quickshell.execDetached(["playerctl", "previous"])
        }
    }

    function nodeTitle(node, fallback) {
        if (!node) return fallback
        if (node.description && node.description.trim() !== "") return node.description.trim()
        if (node.nickname && node.nickname.trim() !== "") return node.nickname.trim()
        if (node.properties && node.properties["node.description"]) return node.properties["node.description"]
        if (node.name) return node.name
        return fallback
    }

    function streamTitle(node) {
        if (!node) return "App"
        if (node.properties) {
            if (node.properties["application.name"]) return node.properties["application.name"]
            if (node.properties["media.name"]) return node.properties["media.name"]
        }
        return nodeTitle(node, "Application")
    }

    Rectangle {
        id: audioFrame
        anchors.top: parent.top
        anchors.topMargin: 4
        anchors.horizontalCenter: parent.horizontalCenter

        implicitWidth: 320
        implicitHeight: mainLayout.implicitHeight + 28
        radius: Theme.radius
        color: Theme.bg0
        border.width: 1
        border.color: Theme.bg2

        ColumnLayout {
            id: mainLayout
            anchors.fill: parent
            anchors.margins: 14
            spacing: 12

            // Header: Title & Pavucontrol button
            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "󰕾  Sound & Volume"
                    font.family: Theme.fontMono
                    font.pixelSize: Theme.fontSizeNormal
                    font.bold: true
                    color: Theme.fgHigh
                }

                Item { Layout.fillWidth: true }

                Rectangle {
                    implicitWidth: pavuText.implicitWidth + 12
                    implicitHeight: 22
                    radius: Theme.radius
                    color: pavuMouse.containsMouse ? Theme.bg2 : Theme.bg1

                    Text {
                        id: pavuText
                        anchors.centerIn: parent
                        text: "Mixer 󰒓"
                        font.family: Theme.fontMono
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.fgDim
                    }

                    MouseArea {
                        id: pavuMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            audioWindow.visible = false
                            Quickshell.execDetached(["pavucontrol"])
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Theme.bg2
            }

            // Master Output Volume
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 6

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: "Output Volume"
                        font.family: Theme.fontMono
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.fgDim
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: {
                            if (!audioWindow.sink || !audioWindow.sink.audio) return "0%"
                            if (audioWindow.sink.audio.muted) return "Muted"
                            return Math.round(audioWindow.sink.audio.volume * 100) + "%"
                        }
                        font.family: Theme.fontMono
                        font.pixelSize: Theme.fontSizeSmall
                        font.bold: true
                        color: Theme.fgHigh
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Rectangle {
                        implicitWidth: 26
                        implicitHeight: 26
                        radius: Theme.radius
                        color: muteMouse.containsMouse ? Theme.bg2 : Theme.bg1

                        Text {
                            anchors.centerIn: parent
                            text: (audioWindow.sink && audioWindow.sink.audio && audioWindow.sink.audio.muted) ? "󰝟" : "󰕾"
                            font.family: Theme.fontMono
                            font.pixelSize: Theme.fontSizeNormal
                            color: Theme.fgHigh
                        }

                        MouseArea {
                            id: muteMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (audioWindow.sink && audioWindow.sink.audio) {
                                    audioWindow.sink.audio.muted = !audioWindow.sink.audio.muted
                                }
                            }
                        }
                    }

                    // Interactive Master Slider
                    Item {
                        id: masterSlider
                        Layout.fillWidth: true
                        implicitHeight: 22

                        readonly property real currentVal: (audioWindow.sink && audioWindow.sink.audio) ? audioWindow.sink.audio.volume : 0

                        Rectangle {
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width
                            height: 6
                            radius: Theme.radius
                            color: Theme.bg2

                            Rectangle {
                                width: parent.width * Math.max(0, Math.min(1, masterSlider.currentVal))
                                height: parent.height
                                radius: parent.radius
                                color: (audioWindow.sink && audioWindow.sink.audio && audioWindow.sink.audio.muted) ? Theme.fgMuted : Theme.accent
                            }
                        }

                        Rectangle {
                            x: Math.max(0, Math.min(parent.width - width, (parent.width - width) * masterSlider.currentVal))
                            anchors.verticalCenter: parent.verticalCenter
                            width: 14
                            height: 14
                            radius: Theme.radius
                            color: Theme.fgHigh
                            border.width: 1
                            border.color: Theme.bg0
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            function applyPos(mouse) {
                                if (audioWindow.sink && audioWindow.sink.audio) {
                                    let v = Math.max(0.0, Math.min(1.0, mouse.x / width))
                                    audioWindow.sink.audio.volume = v
                                    if (audioWindow.sink.audio.muted && v > 0) {
                                        audioWindow.sink.audio.muted = false
                                    }
                                }
                            }
                            onPressed: mouse => applyPos(mouse)
                            onPositionChanged: mouse => { if (pressed) applyPos(mouse) }
                        }
                    }
                }
            }

            // Output Devices List
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                Text {
                    text: "Output Device"
                    font.family: Theme.fontMono
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.fgDim
                }

                Repeater {
                    model: audioWindow.sinks

                    delegate: Rectangle {
                        required property var modelData
                        Layout.fillWidth: true
                        implicitHeight: 26
                        radius: Theme.radius
                        readonly property bool isCurrent: audioWindow.sink && audioWindow.sink.id === modelData.id
                        color: devMouse.containsMouse ? Theme.bg2 : (isCurrent ? Theme.bg1 : "transparent")

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 8
                            anchors.rightMargin: 8
                            spacing: 6

                            Text {
                                text: parent.parent.isCurrent ? "󰄲" : "󰄱"
                                font.family: Theme.fontMono
                                font.pixelSize: Theme.fontSizeSmall
                                color: parent.parent.isCurrent ? Theme.accent : Theme.fgMuted
                            }

                            Text {
                                Layout.fillWidth: true
                                text: audioWindow.nodeTitle(modelData, "Audio Output")
                                font.family: Theme.fontMono
                                font.pixelSize: Theme.fontSizeSmall
                                font.bold: parent.parent.isCurrent
                                color: parent.parent.isCurrent ? Theme.fgHigh : Theme.fgText
                                elide: Text.ElideRight
                            }
                        }

                        MouseArea {
                            id: devMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                Pipewire.preferredDefaultAudioSink = modelData
                            }
                        }
                    }
                }
            }

            // Microphone Input Section
            ColumnLayout {
                visible: audioWindow.source !== null
                Layout.fillWidth: true
                spacing: 6

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: Theme.bg2
                }

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: "Microphone"
                        font.family: Theme.fontMono
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.fgDim
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: {
                            if (!audioWindow.source || !audioWindow.source.audio) return "0%"
                            if (audioWindow.source.audio.muted) return "Muted"
                            return Math.round(audioWindow.source.audio.volume * 100) + "%"
                        }
                        font.family: Theme.fontMono
                        font.pixelSize: Theme.fontSizeSmall
                        font.bold: true
                        color: Theme.fgHigh
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Rectangle {
                        implicitWidth: 26
                        implicitHeight: 26
                        radius: Theme.radius
                        color: micMuteMouse.containsMouse ? Theme.bg2 : Theme.bg1

                        Text {
                            anchors.centerIn: parent
                            text: (audioWindow.source && audioWindow.source.audio && audioWindow.source.audio.muted) ? "󰍭" : "󰍬"
                            font.family: Theme.fontMono
                            font.pixelSize: Theme.fontSizeNormal
                            color: Theme.fgHigh
                        }

                        MouseArea {
                            id: micMuteMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (audioWindow.source && audioWindow.source.audio) {
                                    audioWindow.source.audio.muted = !audioWindow.source.audio.muted
                                }
                            }
                        }
                    }

                    // Interactive Mic Slider
                    Item {
                        id: micSlider
                        Layout.fillWidth: true
                        implicitHeight: 22

                        readonly property real currentVal: (audioWindow.source && audioWindow.source.audio) ? audioWindow.source.audio.volume : 0

                        Rectangle {
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width
                            height: 6
                            radius: Theme.radius
                            color: Theme.bg2

                            Rectangle {
                                width: parent.width * Math.max(0, Math.min(1, micSlider.currentVal))
                                height: parent.height
                                radius: parent.radius
                                color: (audioWindow.source && audioWindow.source.audio && audioWindow.source.audio.muted) ? Theme.fgMuted : Theme.accent
                            }
                        }

                        Rectangle {
                            x: Math.max(0, Math.min(parent.width - width, (parent.width - width) * micSlider.currentVal))
                            anchors.verticalCenter: parent.verticalCenter
                            width: 14
                            height: 14
                            radius: Theme.radius
                            color: Theme.fgHigh
                            border.width: 1
                            border.color: Theme.bg0
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            function applyPos(mouse) {
                                if (audioWindow.source && audioWindow.source.audio) {
                                    let v = Math.max(0.0, Math.min(1.0, mouse.x / width))
                                    audioWindow.source.audio.volume = v
                                    if (audioWindow.source.audio.muted && v > 0) {
                                        audioWindow.source.audio.muted = false
                                    }
                                }
                            }
                            onPressed: mouse => applyPos(mouse)
                            onPositionChanged: mouse => { if (pressed) applyPos(mouse) }
                        }
                    }
                }
            }

            // Per-App Volume Streams (if active)
            ColumnLayout {
                visible: audioWindow.appStreams.length > 0
                Layout.fillWidth: true
                spacing: 6

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: Theme.bg2
                }

                Text {
                    text: "Application Volumes"
                    font.family: Theme.fontMono
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.fgDim
                }

                Repeater {
                    model: audioWindow.appStreams

                    delegate: ColumnLayout {
                        id: streamDelegate
                        required property var modelData
                        Layout.fillWidth: true
                        spacing: 2

                        RowLayout {
                            Layout.fillWidth: true

                            Text {
                                Layout.fillWidth: true
                                text: audioWindow.streamTitle(streamDelegate.modelData)
                                font.family: Theme.fontMono
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.fgText
                                elide: Text.ElideRight
                            }

                            Text {
                                text: {
                                    if (!streamDelegate.modelData.audio) return "0%"
                                    if (streamDelegate.modelData.audio.muted) return "Muted"
                                    return Math.round(streamDelegate.modelData.audio.volume * 100) + "%"
                                }
                                font.family: Theme.fontMono
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.fgMuted
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 6

                            Rectangle {
                                implicitWidth: 20
                                implicitHeight: 20
                                radius: Theme.radius
                                color: streamMuteMouse.containsMouse ? Theme.bg2 : Theme.bg1

                                Text {
                                    anchors.centerIn: parent
                                    text: (streamDelegate.modelData.audio && streamDelegate.modelData.audio.muted) ? "󰝟" : "󰕾"
                                    font.family: Theme.fontMono
                                    font.pixelSize: 10
                                    color: Theme.fgHigh
                                }

                                MouseArea {
                                    id: streamMuteMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        if (streamDelegate.modelData.audio) {
                                            streamDelegate.modelData.audio.muted = !streamDelegate.modelData.audio.muted
                                        }
                                    }
                                }
                            }

                            Item {
                                id: streamSlider
                                Layout.fillWidth: true
                                implicitHeight: 18

                                readonly property real currentVal: streamDelegate.modelData.audio ? streamDelegate.modelData.audio.volume : 0

                                Rectangle {
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.width
                                    height: 4
                                    radius: Theme.radius
                                    color: Theme.bg2

                                    Rectangle {
                                        width: parent.width * Math.max(0, Math.min(1, streamSlider.currentVal))
                                        height: parent.height
                                        radius: parent.radius
                                        color: (streamDelegate.modelData.audio && streamDelegate.modelData.audio.muted) ? Theme.fgMuted : Theme.accent
                                    }
                                }

                                Rectangle {
                                    x: Math.max(0, Math.min(parent.width - width, (parent.width - width) * streamSlider.currentVal))
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: 10
                                    height: 10
                                    radius: Theme.radius
                                    color: Theme.fgHigh
                                    border.width: 1
                                    border.color: Theme.bg0
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    function applyPos(mouse) {
                                        if (streamDelegate.modelData.audio) {
                                            let v = Math.max(0.0, Math.min(1.0, mouse.x / width))
                                            streamDelegate.modelData.audio.volume = v
                                            if (streamDelegate.modelData.audio.muted && v > 0) {
                                                streamDelegate.modelData.audio.muted = false
                                            }
                                        }
                                    }
                                    onPressed: mouse => applyPos(mouse)
                                    onPositionChanged: mouse => { if (pressed) applyPos(mouse) }
                                }
                            }
                        }
                    }
                }
            }

            // MPRIS Media Controller (if active)
            ColumnLayout {
                visible: audioWindow.activePlayer !== null
                Layout.fillWidth: true
                spacing: 6

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: Theme.bg2
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 1

                        Text {
                            Layout.fillWidth: true
                            text: audioWindow.activePlayer ? (audioWindow.activePlayer.trackTitle || "No Track") : ""
                            font.family: Theme.fontMono
                            font.pixelSize: Theme.fontSizeSmall
                            font.bold: true
                            color: Theme.fgHigh
                            elide: Text.ElideRight
                        }

                        Text {
                            Layout.fillWidth: true
                            text: audioWindow.playerArtist(audioWindow.activePlayer)
                            font.family: Theme.fontMono
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.fgDim
                            elide: Text.ElideRight
                        }
                    }

                    // Playback Controls
                    RowLayout {
                        spacing: 4

                        Rectangle {
                            implicitWidth: 24
                            implicitHeight: 24
                            radius: Theme.radius
                            color: prevMouse.containsMouse ? Theme.bg2 : Theme.bg1

                            Text {
                                anchors.centerIn: parent
                                text: "󰒮"
                                font.family: Theme.fontMono
                                font.pixelSize: Theme.fontSizeNormal
                                color: Theme.fgHigh
                            }

                            MouseArea {
                                id: prevMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: audioWindow.previousTrack()
                            }
                        }

                        Rectangle {
                            implicitWidth: 24
                            implicitHeight: 24
                            radius: Theme.radius
                            color: playMouse.containsMouse ? Theme.bg2 : Theme.accent

                            Text {
                                anchors.centerIn: parent
                                text: (audioWindow.activePlayer && audioWindow.activePlayer.playbackState === MprisPlaybackState.Playing) ? "󰏤" : "󰐊"
                                font.family: Theme.fontMono
                                font.pixelSize: Theme.fontSizeNormal
                                color: Theme.bg0
                            }

                            MouseArea {
                                id: playMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: audioWindow.togglePlay()
                            }
                        }

                        Rectangle {
                            implicitWidth: 24
                            implicitHeight: 24
                            radius: Theme.radius
                            color: nextMouse.containsMouse ? Theme.bg2 : Theme.bg1

                            Text {
                                anchors.centerIn: parent
                                text: "󰒭"
                                font.family: Theme.fontMono
                                font.pixelSize: Theme.fontSizeNormal
                                color: Theme.fgHigh
                            }

                            MouseArea {
                                id: nextMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: audioWindow.nextTrack()
                            }
                        }
                    }
                }
            }
        }
    }
}
