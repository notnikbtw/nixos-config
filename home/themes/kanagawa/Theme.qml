pragma Singleton
import QtQuick

QtObject {
    readonly property color bg0: "#16161d"
    readonly property color bg1: "#1f1f28"
    readonly property color bg2: "#2a2a37"
    readonly property color bg3: "#363646"
    readonly property color bg4: "#54546d"

    readonly property color fg0: "#dcd7ba"
    readonly property color fg1: "#c8c093"
    readonly property color fg2: "#a6a084"
    readonly property color gray: "#727169"

    readonly property color fgHigh:  "#dcd7ba"
    readonly property color fgText:  "#c8c093"
    readonly property color fgSub:   "#a6a084"
    readonly property color fgDim:   "#727169"
    readonly property color fgMuted: "#54546d"

    readonly property color red:    "#c34043"
    readonly property color green:  "#76946a"
    readonly property color yellow: "#c0a36e"
    readonly property color blue:   "#7e9cd8"
    readonly property color purple: "#957fb8"
    readonly property color aqua:   "#7aa89f"
    readonly property color accent: blue
    readonly property color orange: "#ffa066"

    readonly property string fontMono: FontConfig.family
    readonly property int fontSizeNormal: FontConfig.sizeNormal
    readonly property int fontSizeSmall: FontConfig.sizeSmall
    readonly property int barHeight: 32
    readonly property int radius: 0
}
