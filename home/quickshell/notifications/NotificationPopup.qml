import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import ".."

PanelWindow {
    id: notifWindow

    anchors {
        top: true
        right: true
    }

    visible: server.trackedNotifications.values.length > 0
    implicitWidth: notifList.implicitWidth + 24
    implicitHeight: notifList.implicitHeight + Theme.barHeight + 24

    WlrLayershell.layer: WlrLayer.Overlay
    exclusiveZone: 0
    color: "transparent"

    NotificationServer {
        id: server
        bodySupported: true
        actionsSupported: false
        imageSupported: true

        onNotification: notification => {
            notification.tracked = true
        }
    }

    ColumnLayout {
        id: notifList
        spacing: 10
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: Theme.barHeight + 10
        anchors.rightMargin: 12

        Repeater {
            model: server.trackedNotifications.values

            delegate: Rectangle {
                id: card
                required property var modelData

                implicitWidth: 340
                implicitHeight: cardContent.implicitHeight + 24
                
                color: Theme.bg1
                border.color: Theme.bg3
                border.width: 1
                radius: Theme.radius

                Timer {
                    interval: card.modelData.expireTimeout > 0 ? card.modelData.expireTimeout : 5000
                    running: card.modelData.urgency !== NotificationUrgency.Critical
                    onTriggered: card.modelData.dismiss()
                }

                ColumnLayout {
                    id: cardContent
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 6

                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: (card.modelData.appName && card.modelData.appName.length > 0)
                                  ? card.modelData.appName
                                  : "Notification"
                            font.family: Theme.fontMono
                            font.pixelSize: Theme.fontSizeSmall
                            font.bold: true
                            color: Theme.fgDim
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }

                        Text {
                            text: "✕"
                            font.family: Theme.fontMono
                            font.pixelSize: Theme.fontSizeNormal
                            color: closeMouse.containsMouse ? Theme.fgHigh : Theme.fgMuted

                            MouseArea {
                                id: closeMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: card.modelData.dismiss()
                            }
                        }
                    }

                    Text {
                        text: card.modelData.summary || ""
                        font.family: Theme.fontMono
                        font.pixelSize: Theme.fontSizeNormal
                        font.bold: true
                        color: Theme.fgHigh
                        wrapMode: Text.Wrap
                        Layout.fillWidth: true
                        visible: text.length > 0
                    }

                    Text {
                        text: card.modelData.body || ""
                        font.family: Theme.fontMono
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.fgText
                        wrapMode: Text.Wrap
                        Layout.fillWidth: true
                        visible: text.length > 0
                    }
                }
            }
        }
    }
}
