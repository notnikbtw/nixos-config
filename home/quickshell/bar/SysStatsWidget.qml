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

    // Read straight from /proc (no process spawn)
    FileView {
        id: statFile
        path: "/proc/stat"
        onLoaded: {
            const cpu = text().split("\n", 1)[0].trim().split(/\s+/).slice(1).map(Number)
            if (cpu.length < 5) return

            const idle = cpu[3] + cpu[4]
            const total = cpu.reduce((sum, v) => sum + v, 0)
            if (root.prevTotal > 0) {
                const diffIdle = idle - root.prevIdle
                const diffTotal = total - root.prevTotal
                if (diffTotal > 0)
                    root.cpuPercent = Math.max(0, Math.min(100, Math.round((1 - diffIdle / diffTotal) * 100)))
            }
            root.prevIdle = idle
            root.prevTotal = total
        }
    }

    FileView {
        id: memFile
        path: "/proc/meminfo"
        onLoaded: {
            const mem = text()
            const total = parseInt((mem.match(/^MemTotal:\s+(\d+)/m) || [])[1])
            const avail = parseInt((mem.match(/^MemAvailable:\s+(\d+)/m) || [])[1])
            if (total > 0 && !isNaN(avail))
                root.memPercent = Math.round((total - avail) * 100 / total)
        }
    }

    function update() {
        statFile.reload()
        memFile.reload()
    }

    Component.onCompleted: update()

    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: root.update()
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
