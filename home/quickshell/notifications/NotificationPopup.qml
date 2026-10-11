import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import ".."

PanelWindow {
    id: notifWindow

    readonly property int maxVisible: 5
    readonly property int defaultTimeout: 5000

    anchors {
        top: true
        right: true
    }

    visible: server.trackedNotifications.values.length > 0
    implicitWidth: notifList.implicitWidth + 24
    implicitHeight: notifList.implicitHeight + Theme.barHeight + 24

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    exclusiveZone: 0
    color: "transparent"

    mask: Region { item: notifList }

    NotificationServer {
        id: server
        bodySupported: true
        bodyMarkupSupported: true
        bodyHyperlinksSupported: false
        actionsSupported: true
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
            model: server.trackedNotifications.values.slice(0, notifWindow.maxVisible)

            delegate: Rectangle {
                id: card
                required property var modelData

                readonly property bool critical: modelData.urgency === NotificationUrgency.Critical
                readonly property bool low: modelData.urgency === NotificationUrgency.Low
                readonly property color levelColor: critical ? Theme.red
                                                  : low ? Theme.fgMuted
                                                  : Theme.accent

                readonly property var defaultAction: {
                    const list = modelData.actions || []
                    for (let i = 0; i < list.length; i++) {
                        if (list[i].identifier === "default") return list[i]
                    }
                    return null
                }
                readonly property var extraActions: {
                    const list = modelData.actions || []
                    return list.filter(a => a.identifier !== "default")
                }

                readonly property string iconSource: {
                    if (modelData.image && modelData.image.length > 0) return modelData.image
                    const icon = modelData.appIcon || ""
                    if (icon.length === 0) return ""
                    if (icon.startsWith("/")) return "file://" + icon
                    return Quickshell.iconPath(icon, true)
                }

                readonly property int timeoutMs: modelData.expireTimeout > 0
                                                 ? Math.round(modelData.expireTimeout * 1000)
                                                 : notifWindow.defaultTimeout

                property real enter: 0
                property real remaining: 1

                implicitWidth: 360
                implicitHeight: content.implicitHeight + 24

                color: Theme.bg1
                border.color: critical ? Theme.red : Theme.bg3
                border.width: 1
                radius: Theme.radius

                opacity: enter
                transform: Translate { x: (1 - card.enter) * 40 }

                NumberAnimation on enter {
                    from: 0
                    to: 1
                    duration: 180
                    easing.type: Easing.OutCubic
                }

                NumberAnimation on remaining {
                    from: 1
                    to: 0
                    duration: card.timeoutMs
                    running: !card.critical
                    paused: hover.hovered
                    onFinished: card.modelData.expire()
                }

                HoverHandler { id: hover }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    cursorShape: Qt.PointingHandCursor
                    onClicked: mouse => {
                        if (mouse.button === Qt.LeftButton && card.defaultAction)
                            card.defaultAction.invoke()
                        card.modelData.dismiss()
                    }
                }

                Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: 3
                    color: card.levelColor
                }

                RowLayout {
                    id: content
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 12
                    anchors.topMargin: 12
                    anchors.bottomMargin: 12
                    spacing: 12

                    Image {
                        visible: card.iconSource.length > 0 && status !== Image.Error
                        source: card.iconSource
                        sourceSize.width: 96
                        sourceSize.height: 96
                        fillMode: Image.PreserveAspectFit
                        asynchronous: true
                        Layout.preferredWidth: 40
                        Layout.preferredHeight: 40
                        Layout.alignment: Qt.AlignTop
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4

                        RowLayout {
                            Layout.fillWidth: true

                            Text {
                                text: (card.modelData.appName && card.modelData.appName.length > 0)
                                      ? card.modelData.appName
                                      : "Notification"
                                font.family: Theme.fontMono
                                font.pixelSize: Theme.fontSizeSmall
                                font.bold: true
                                color: card.critical ? Theme.red : Theme.fgDim
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
                                    anchors.margins: -6
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: card.modelData.dismiss()
                                }
                            }
                        }

                        Text {
                            text: card.modelData.summary || ""
                            textFormat: Text.PlainText
                            font.family: Theme.fontMono
                            font.pixelSize: Theme.fontSizeNormal
                            font.bold: true
                            color: Theme.fgHigh
                            wrapMode: Text.Wrap
                            maximumLineCount: 2
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                            visible: text.length > 0
                        }

                        Text {
                            text: card.modelData.body || ""
                            textFormat: Text.StyledText
                            font.family: Theme.fontMono
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.fgText
                            wrapMode: Text.Wrap
                            maximumLineCount: 6
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                            visible: text.length > 0
                        }

                        Flow {
                            Layout.fillWidth: true
                            Layout.topMargin: 4
                            spacing: 6
                            visible: card.extraActions.length > 0

                            Repeater {
                                model: card.extraActions

                                delegate: Rectangle {
                                    id: actionButton
                                    required property var modelData

                                    implicitWidth: actionLabel.implicitWidth + 20
                                    implicitHeight: actionLabel.implicitHeight + 10
                                    color: actionMouse.containsMouse ? Theme.bg3 : Theme.bg2
                                    border.color: Theme.bg4
                                    border.width: 1
                                    radius: Theme.radius

                                    Text {
                                        id: actionLabel
                                        anchors.centerIn: parent
                                        text: actionButton.modelData.text
                                        font.family: Theme.fontMono
                                        font.pixelSize: Theme.fontSizeSmall
                                        color: Theme.fgHigh
                                    }

                                    MouseArea {
                                        id: actionMouse
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            actionButton.modelData.invoke()
                                            card.modelData.dismiss()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    visible: !card.critical
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 1
                    anchors.bottomMargin: 1
                    height: 2
                    width: Math.max(0, (parent.width - 2) * card.remaining)
                    color: card.levelColor
                    opacity: 0.7
                }
            }
        }
    }
}
