import Quickshell
import Quickshell.Wayland
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts
import ".."

PanelWindow {
    id: barWindow
    property var modelData
    screen: modelData

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: Theme.barHeight
    color: Theme.bg0

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    exclusiveZone: Theme.barHeight

    Item {
        anchors.fill: parent

        RowLayout {
            id: leftSec
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8

            Workspaces {}
        }

        RowLayout {
            id: centerSec
            anchors.centerIn: parent
            spacing: 8

            NightLightWidget {}

            StayAwakeWidget {}

            ScreenRecordWidget {
                screenName: barWindow.screen ? barWindow.screen.name : ""
            }

            PrivacyWidget {}

            Clock {
                id: centerClock
            }
        }

        RowLayout {
            id: rightSec
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            spacing: 12

            SysStatsWidget {}

            PowerProfileWidget {}

            BatteryWidget {}

            AudioWidget {}

            BluetoothWidget {}

            NetworkWidget {}

            Rectangle {
                width: 1
                height: 14
                color: Theme.bg2
                visible: SystemTray.items.values.length > 0
            }

            SysTrayWidget {
                visible: SystemTray.items.values.length > 0
            }
        }
    }
}
