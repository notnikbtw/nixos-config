//@ pragma UseQApplication
import Quickshell
import QtQuick
import "bar"
import "notifications"
import "osd"

ShellRoot {
    id: rootShell

    NotificationPopup {}
    OSD {}

    Variants {
        model: Quickshell.screens

        delegate: Component {
            Bar {}
        }
    }
}
