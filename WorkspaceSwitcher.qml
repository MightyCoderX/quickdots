import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

import "config.js" as Config

RowLayout {
    id: root

    property bool currentMonitorOnly: true

    Repeater {
        model: Hyprland.workspaces

        Rectangle {
            property bool isBarMonitor: modelData.monitor?.name === Screen?.name

            visible: currentMonitorOnly ? isBarMonitor && modelData.id > 0 : true
            Layout.fillHeight: visible
            Layout.preferredWidth: height

            color: mouseArea.containsMouse ? Config.colors.muted : Config.colors.bgDark

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: modelData.activate()
            }

            Text {
                id: contentText
                anchors.centerIn: parent
                text: modelData.id
                color: modelData.active ? Config.colors.cyan : Config.colors.fg
                font.bold: modelData.active
                font.family: Config.bar.fontFamily
                font.pixelSize: Config.bar.fontSize - 2
            }
        }
    }
}
