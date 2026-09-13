pragma Singleton
import QtQuick

QtObject {
    readonly property color bg0: "#1d2021"
    readonly property color bg1: "#282828"
    readonly property color bg2: "#3c3836"
    readonly property color bg3: "#504945"
    readonly property color bg4: "#665c54"

    readonly property color fg0: "#fbf1c7"
    readonly property color fg1: "#ebdbb2"
    readonly property color fg2: "#d5c4a1"
    readonly property color gray: "#928374"

    readonly property color fgHigh:  "#fbf1c7"
    readonly property color fgText:  "#ebdbb2"
    readonly property color fgSub:   "#d5c4a1"
    readonly property color fgDim:   "#928374"
    readonly property color fgMuted: "#7c6f64"

    readonly property color red:    "#fb4934"
    readonly property color green:  "#b8bb26"
    readonly property color yellow: "#fabd2f"
    readonly property color blue:   "#83a598"
    readonly property color purple: "#d3869b"
    readonly property color aqua:   "#8ec07c"
    readonly property color orange: "#fe8019"

    readonly property string fontMono: FontConfig.family
    readonly property int fontSizeNormal: FontConfig.sizeNormal
    readonly property int fontSizeSmall: FontConfig.sizeSmall
    readonly property int barHeight: 32
    readonly property int radius: 2
}
