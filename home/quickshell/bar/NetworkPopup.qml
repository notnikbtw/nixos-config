import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import ".."

PopupWindow {
    id: netWindow

    color: "transparent"
    grabFocus: true

    anchor {
        gravity: Edges.Bottom
        edges: Edges.Bottom
    }

    implicitWidth: netFrame.implicitWidth
    implicitHeight: netFrame.implicitHeight + 8

    HyprlandFocusGrab {
        windows: [netWindow]
        active: netWindow.visible
        onCleared: netWindow.visible = false
    }

    property string iface: ""
    property string localIp: "..."
    property string gateway: "..."
    property string ssid: ""
    property bool isWifi: iface.startsWith("w") || ssid !== ""
    property bool isOnline: iface !== "" && iface !== "none"
    property bool showQr: false
    property string qrImagePath: ""
    property string wifiPsk: ""

    onVisibleChanged: {
        if (visible) {
            netWindow.showQr = false
            queryNet.running = true
            querySsid.running = true
            qrGenerator.running = true
        }
    }

    Process {
        id: qrGenerator
        command: ["bash", Quickshell.shellDir + "/scripts/wifi-qr.sh"]
        stdout: SplitParser {
            onRead: data => {
                try {
                    let parsed = JSON.parse(data.trim())
                    if (parsed.qrPath) {
                        netWindow.qrImagePath = parsed.qrPath
                    }
                    if (parsed.psk !== undefined) {
                        netWindow.wifiPsk = parsed.psk
                    }
                    if (parsed.ssid) {
                        netWindow.ssid = parsed.ssid
                    }
                } catch(e) {}
            }
        }
    }

    // Query detailed network info on open
    Process {
        id: queryNet
        command: ["sh", "-c", "ip route get 1.1.1.1 2>/dev/null | awk '{print $5, $7, $3}' || echo 'none none none'"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                let parts = data.trim().split(/\s+/)
                if (parts.length >= 3) {
                    netWindow.iface = parts[0]
                    netWindow.localIp = parts[1]
                    netWindow.gateway = parts[2]
                }
            }
        }
    }

    Process {
        id: querySsid
        command: ["sh", "-c", "nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes:' | cut -d: -f2 || echo ''"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                netWindow.ssid = data.trim()
            }
        }
    }

    Rectangle {
        id: netFrame
        anchors.top: parent.top
        anchors.topMargin: 4
        anchors.horizontalCenter: parent.horizontalCenter

        implicitWidth: 280
        implicitHeight: netLayout.implicitHeight + 24
        radius: Theme.radius
        color: Theme.bg0
        border.width: 1
        border.color: Theme.bg2

        ColumnLayout {
            id: netLayout
            anchors.fill: parent
            anchors.margins: 14
            spacing: 12

            // Header
            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: netWindow.isWifi ? "  Wi-Fi Network" : (netWindow.isOnline ? "󰈀  Ethernet" : "󰤮  Network")
                    font.family: Theme.fontMono
                    font.pixelSize: Theme.fontSizeNormal
                    font.bold: true
                    color: Theme.fgHigh
                }

                Item { Layout.fillWidth: true }

                Rectangle {
                    implicitWidth: nmText.implicitWidth + 12
                    implicitHeight: 22
                    radius: Theme.radius
                    color: nmMouse.containsMouse ? Theme.bg2 : Theme.bg1

                    Text {
                        id: nmText
                        anchors.centerIn: parent
                        text: "Manage 󰒓"
                        font.family: Theme.fontMono
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.fgDim
                    }

                    MouseArea {
                        id: nmMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            netWindow.visible = false
                            Quickshell.execDetached(["nm-connection-editor"])
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Theme.bg2
            }

            // Connection Details
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 6

                // Status row
                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: "Status"
                        font.family: Theme.fontMono
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.fgDim
                    }

                    Item { Layout.fillWidth: true }

                    Rectangle {
                        implicitWidth: statusText.implicitWidth + 8
                        implicitHeight: 18
                        radius: Theme.radius
                        color: netWindow.isOnline ? Theme.green : Theme.red

                        Text {
                            id: statusText
                            anchors.centerIn: parent
                            text: netWindow.isOnline ? "Connected" : "Disconnected"
                            font.family: Theme.fontMono
                            font.pixelSize: 10
                            font.bold: true
                            color: Theme.bg0
                        }
                    }
                }

                // SSID row if WiFi
                RowLayout {
                    visible: netWindow.ssid !== ""
                    Layout.fillWidth: true

                    Text {
                        text: "Network (SSID)"
                        font.family: Theme.fontMono
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.fgDim
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: netWindow.ssid
                        font.family: Theme.fontMono
                        font.pixelSize: Theme.fontSizeSmall
                        font.bold: true
                        color: Theme.accent
                    }
                }

                // Interface row
                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: "Interface"
                        font.family: Theme.fontMono
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.fgDim
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: netWindow.iface || "None"
                        font.family: Theme.fontMono
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.fgText
                    }
                }

                // Local IP row
                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: "IP Address"
                        font.family: Theme.fontMono
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.fgDim
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: netWindow.localIp
                        font.family: Theme.fontMono
                        font.pixelSize: Theme.fontSizeSmall
                        font.bold: true
                        color: Theme.fgHigh
                    }
                }

                // Gateway row
                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: "Gateway"
                        font.family: Theme.fontMono
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.fgDim
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: netWindow.gateway
                        font.family: Theme.fontMono
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.fgText
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Theme.bg2
            }

            // Wi-Fi QR Card
            ColumnLayout {
                visible: netWindow.showQr
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                spacing: 8

                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    width: 140
                    height: 140
                    color: "white"
                    radius: Theme.radius

                    Image {
                        anchors.centerIn: parent
                        width: 130
                        height: 130
                        source: netWindow.qrImagePath.length > 0 ? ("file://" + netWindow.qrImagePath) : ""
                        fillMode: Image.PreserveAspectFit
                        cache: false

                        Text {
                            anchors.centerIn: parent
                            visible: netWindow.qrImagePath.length === 0
                            text: "Generating..."
                            font.family: Theme.fontMono
                            font.pixelSize: Theme.fontSizeSmall
                            color: "#333333"
                        }
                    }
                }

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 6

                    Text {
                        text: netWindow.wifiPsk ? ("Password: " + netWindow.wifiPsk) : "Open Network"
                        font.family: Theme.fontMono
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.accent
                    }

                    Rectangle {
                        visible: netWindow.wifiPsk.length > 0
                        implicitWidth: 20
                        implicitHeight: 20
                        radius: Theme.radius
                        color: copyPskMouse.containsMouse ? Theme.bg2 : Theme.bg1

                        Text {
                            anchors.centerIn: parent
                            text: "󰅍"
                            font.family: Theme.fontMono
                            font.pixelSize: 10
                            color: Theme.fgHigh
                        }

                        MouseArea {
                            id: copyPskMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                Quickshell.execDetached(["wl-copy", netWindow.wifiPsk])
                            }
                        }
                    }
                }
            }

            // Action Buttons
            RowLayout {
                Layout.fillWidth: true
                spacing: 6

                Rectangle {
                    visible: netWindow.isWifi
                    Layout.fillWidth: true
                    implicitHeight: 26
                    radius: Theme.radius
                    color: qrMouse.containsMouse ? Theme.bg2 : Theme.bg1

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 4

                        Text {
                            text: "󰐲"
                            font.family: Theme.fontMono
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.accent
                        }

                        Text {
                            text: netWindow.showQr ? "Hide QR" : "Share QR"
                            font.family: Theme.fontMono
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.fgText
                        }
                    }

                    MouseArea {
                        id: qrMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            netWindow.showQr = !netWindow.showQr
                            if (netWindow.showQr && netWindow.qrImagePath.length === 0) {
                                qrGenerator.running = true
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 26
                    radius: Theme.radius
                    color: copyMouse.containsMouse ? Theme.bg2 : Theme.bg1

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 4

                        Text {
                            text: "󰅍"
                            font.family: Theme.fontMono
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.fgHigh
                        }

                        Text {
                            text: "Copy IP"
                            font.family: Theme.fontMono
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.fgText
                        }
                    }

                    MouseArea {
                        id: copyMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            Quickshell.execDetached(["wl-copy", netWindow.localIp])
                            netWindow.visible = false
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 26
                    radius: Theme.radius
                    color: refreshMouse.containsMouse ? Theme.bg2 : Theme.bg1

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 4

                        Text {
                            text: "󰑐"
                            font.family: Theme.fontMono
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.fgHigh
                        }

                        Text {
                            text: "Refresh"
                            font.family: Theme.fontMono
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.fgText
                        }
                    }

                    MouseArea {
                        id: refreshMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            queryNet.running = true
                            querySsid.running = true
                        }
                    }
                }
            }
        }
    }
}
