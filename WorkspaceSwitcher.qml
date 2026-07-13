import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

import "config.js" as Config

RowLayout {
    id: root

    property int activeWorkspace

    Process {
        id: launcher
        stderr: SplitParser {
            onRead: data => console.log("hyprctl stderr:", data)
        }
    }

    Repeater {
        model: 10
        Rectangle {
            required property int index

            Layout.fillHeight: true
            Layout.preferredWidth: height

            color: mouseArea.containsMouse ? Config.colors.muted : Config.colors.bgDark

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: e => {
                    launcher.exec(["hyprctl", "dispatch", "hl.dsp.focus({ workspace = '" + (index + 1) + "' })"])
                }
            }

            Text {
                id: contentText
                anchors.centerIn: parent
                text: (index + 1)
                color: activeWorkspace === (index+1) ? Config.colors.cyan : Config.colors.fg
                font.bold: activeWorkspace === (index+1)
                font.family: Config.bar.fontFamily
                font.pixelSize: Config.bar.fontSize - 2
            }
        }
    }
}
