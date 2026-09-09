import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import ".."

Item {
    id: root
    implicitWidth: statsRow.implicitWidth
    implicitHeight: statsRow.implicitHeight

    property int cpuPercent: 0
    property int memPercent: 0

    property real prevIdle: 0
    property real prevTotal: 0

    Process {
        id: statProc
        command: [
            "awk",
            "/^cpu / {idle=$5+$6; for(i=2;i<=NF;i++) total+=$i; print \"cpu\", idle, total; nextfile} /^MemTotal:/ {t=$2} /^MemAvailable:/ {a=$2} END {print \"mem\", int((t-a)*100/t)}",
            "/proc/stat",
            "/proc/meminfo"
        ]
        running: true
        stdout: SplitParser {
            onRead: data => {
                let parts = data.trim().split(/\s+/)
                if (parts.length >= 3 && parts[0] === "cpu") {
                    let idle = parseFloat(parts[1])
                    let total = parseFloat(parts[2])
                    if (root.prevTotal > 0) {
                        let diffIdle = idle - root.prevIdle
                        let diffTotal = total - root.prevTotal
                        if (diffTotal > 0) {
                            root.cpuPercent = Math.max(0, Math.min(100, Math.round((1 - diffIdle / diffTotal) * 100)))
                        }
                    }
                    root.prevIdle = idle
                    root.prevTotal = total
                } else if (parts.length >= 2 && parts[0] === "mem") {
                    let mem = parseInt(parts[1])
                    if (!isNaN(mem)) {
                        root.memPercent = mem
                    }
                }
            }
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: statProc.running = true
    }

    RowLayout {
        id: statsRow
        spacing: 10

        RowLayout {
            spacing: 3
            Text {
                text: ""
                font.family: Theme.fontMono
                font.pixelSize: Theme.fontSizeNormal
                color: Theme.green
            }
            Text {
                text: root.cpuPercent + "%"
                font.family: Theme.fontMono
                font.pixelSize: Theme.fontSizeNormal
                color: Theme.green
            }
        }

        RowLayout {
            spacing: 3
            Text {
                text: ""
                font.family: Theme.fontMono
                font.pixelSize: Theme.fontSizeNormal
                color: Theme.purple
            }
            Text {
                text: root.memPercent + "%"
                font.family: Theme.fontMono
                font.pixelSize: Theme.fontSizeNormal
                color: Theme.purple
            }
        }
    }
}
