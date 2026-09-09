import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import ".."

Item {
    id: root

    property bool micActive: false
    property bool camActive: false

    visible: micActive || camActive

    implicitWidth: row.implicitWidth + 12
    implicitHeight: 22

    // Перевірка раз на 2 секунди
    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            checkMic.running = true
            checkCam.running = true
        }
    }

    // Шукає реальний активний потік захоплення аудіо в PipeWire
    Process {
        id: checkMic
        command: ["sh", "-c", "pw-cli ls Node 2>/dev/null | grep -F '\"Stream/Input/Audio\"' >/dev/null && echo 'on' || echo 'off'"]
        stdout: SplitParser {
            onRead: data => {
                root.micActive = (data.trim() === "on")
            }
        }
    }

    // Перевірка вебкамери через зайняті пристрої ядра Linux
    Process {
        id: checkCam
        command: ["sh", "-c", "fuser /dev/video* >/dev/null 2>&1 && echo 'on' || echo 'off'"]
        stdout: SplitParser {
            onRead: data => {
                root.camActive = (data.trim() === "on")
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: Theme.radius
        color: Theme.bg1
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 6

        Text {
            visible: root.camActive
            text: "󰄀"
            font.family: Theme.fontMono
            font.pixelSize: Theme.fontSizeNormal
            color: Theme.fgHigh
        }

        Text {
            visible: root.micActive
            text: "󰍬"
            font.family: Theme.fontMono
            font.pixelSize: Theme.fontSizeNormal
            color: Theme.fgHigh
        }
    }
}
