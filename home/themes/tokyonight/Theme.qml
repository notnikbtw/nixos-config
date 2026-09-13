pragma Singleton
import QtQuick

QtObject {
    readonly property color bg0: "#16161e"
    readonly property color bg1: "#1a1b26"
    readonly property color bg2: "#24283b"
    readonly property color bg3: "#414868"
    readonly property color bg4: "#565f89"

    readonly property color fg0: "#c0caf5"
    readonly property color fg1: "#a9b1d6"
    readonly property color fg2: "#9aa5ce"
    readonly property color gray: "#565f89"

    readonly property color fgHigh:  "#c0caf5"
    readonly property color fgText:  "#a9b1d6"
    readonly property color fgSub:   "#9aa5ce"
    readonly property color fgDim:   "#565f89"
    readonly property color fgMuted: "#414868"

    readonly property color red:    "#f7768e"
    readonly property color green:  "#9ece6a"
    readonly property color yellow: "#e0af68"
    readonly property color blue:   "#7aa2f7"
    readonly property color purple: "#bb9af7"
    readonly property color aqua:   "#7dcfff"
    readonly property color orange: "#ff9e64"

    readonly property string fontMono: FontConfig.family
    readonly property int fontSizeNormal: FontConfig.sizeNormal
    readonly property int fontSizeSmall: FontConfig.sizeSmall
    readonly property int barHeight: 32
    readonly property int radius: 2
}
