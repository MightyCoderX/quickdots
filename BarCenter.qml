import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

import "config.js" as Config

RowLayout {
    anchors {
        horizontalCenter: parent.horizontalCenter
        top: parent.top
        bottom: parent.bottom
    }

    DateTime {}
}
