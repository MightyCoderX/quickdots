import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

import "../../../base"

import "../../../config.js" as Config

Rectangle {
    id: root
    Layout.fillHeight: true
    Layout.preferredWidth: contentText.implicitWidth + 10

    required property int value

    property string icon: ""
    property string displayValue: value
    property string fgColor: Config.colors.fg

    property bool warning
    property bool critical

    signal clicked(mouse: MouseEvent)

    color: mouseArea.containsMouse ? Config.colors.muted : "transparent"

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: mouse => root.clicked(mouse)
    }

    PanelText {
        id: contentText
        anchors.centerIn: parent
        text: root.icon + " " + root.displayValue
        color: {
            if(root.critical) {
                Config.colors.red
            }
            else if(root.warning) {
                Config.colors.yellow
            }
            else {
                root.fgColor
            }
        }
    }
}
