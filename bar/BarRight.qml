import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Notifications
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts

import "modules"

import "../config.js" as Config

RowLayout {
    id: rightCol
    spacing: 10

    anchors {
        left: centerCol.right
        top: parent.top
        bottom: parent.bottom
        right: parent.right
    }

    Item { Layout.fillWidth: true; }

    // TODO: system tray
    Metrics {}
    Controls {}
    Connections {}
    // TODO: notifications button
}
