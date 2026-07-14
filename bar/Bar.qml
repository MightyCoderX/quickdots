import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

import "../config.js" as Config

PanelWindow {
    anchors {
        left: true
        right: true
        top: true
    }

    implicitHeight: 30
    color: Config.colors.bgDark

    Item {
        anchors {
            fill: parent
            margins: 0
        }

        // center column first to make sure it's always in the center
        // no matter what is on the sides
        BarCenter {
            id: centerCol
        }

        BarLeft {
            id: leftCol
        }

        BarRight {
            id: rightCol
        }
    }
}
