import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

import "config.js" as Config

RowLayout {
    anchors {
        left: parent.left
        right: centerCol.left
        top: parent.top
        bottom: parent.bottom
    }

    spacing: 0

    WorkspaceSwitcher {
        activeWorkspace: 1
    }

    // spacer
    Item { Layout.fillWidth: true }
}

