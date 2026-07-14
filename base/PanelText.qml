import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

import "../config.js" as Config

Text {
    font.family: Config.bar.fontFamily
    font.pixelSize: Config.bar.fontSize - 2
    color: Config.colors.fg
}
