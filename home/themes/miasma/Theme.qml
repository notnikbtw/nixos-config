pragma Singleton
import QtQuick

QtObject {
    readonly property color bg0: "#1a1a1a"
    readonly property color bg1: "#222222"
    readonly property color bg2: "#2b2b2b"
    readonly property color bg3: "#373737"
    readonly property color bg4: "#4d4d42"

    readonly property color fg0: "#d6d6c7"
    readonly property color fg1: "#c2c2b0"
    readonly property color fg2: "#a7a796"
    readonly property color gray: "#666659"

    readonly property color fgHigh:  "#d6d6c7"
    readonly property color fgText:  "#c2c2b0"
    readonly property color fgSub:   "#a7a796"
    readonly property color fgDim:   "#666659"
    readonly property color fgMuted: "#4d4d42"

    readonly property color red:    "#b3554e"
    readonly property color green:  "#78997a"
    readonly property color yellow: "#bca063"
    readonly property color blue:   "#68878f"
    readonly property color purple: "#8c788a"
    readonly property color aqua:   "#6a8f7c"
    readonly property color accent: green
    readonly property color orange: "#bb7757"

    readonly property string fontMono: FontConfig.family
    readonly property int fontSizeNormal: FontConfig.sizeNormal
    readonly property int fontSizeSmall: FontConfig.sizeSmall
    readonly property int barHeight: 32
    readonly property int radius: 0
}
