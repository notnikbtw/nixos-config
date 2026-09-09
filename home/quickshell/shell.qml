//@ pragma UseQApplication
import Quickshell
import QtQuick
import "bar"
import "notifications"

ShellRoot {
    id: rootShell

    NotificationPopup {}

    Variants {
        model: Quickshell.screens

        delegate: Component {
            Bar {}
        }
    }
}
