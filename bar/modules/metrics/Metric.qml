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

    required property double value
    property int maxValue: 100
    property int minValue: 0

    property var icons
    property string icon: {
        if (icons) {
            const intervalSize = (maxValue - minValue) / icons.length;

            for(let i = 0; i < icons.length; i++) {
                const start = i*intervalSize;
                const end = start+intervalSize;
                if(value >= start && value <= end) {
                    return icons[i];
                }
            }
        }
        else {
            return "N/A"
        }
    }
    property string displayValue: value
    property string fgColor: Config.colors.fg

    property bool warning
    property bool critical

    signal clicked(mouse: MouseEvent)
    signal wheel(wheel: WheelEvent)
    signal scrolledUp(wheel: WheelEvent)
    signal scrolledDown(wheel: WheelEvent)

    color: mouseArea.containsMouse ? Config.colors.muted : "transparent"

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: mouse => root.clicked(mouse)
        onWheel: wheel => {
            root.wheel(wheel);
            const delta = wheel.angleDelta.y;
            if(delta > 0) {
                root.scrolledUp(wheel);
            }
            else if(delta < 0) {
                root.scrolledDown(wheel);
            }
        }
    }

    PanelText {
        id: contentText
        anchors.centerIn: parent
        text: root.icon + (root.displayValue ? " " + root.displayValue : "")
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
