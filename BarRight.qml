import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

import "config.js" as Config


RowLayout {
    id: rightCol

    anchors {
        left: centerCol.right
        top: parent.top
        bottom: parent.bottom
    }
}
