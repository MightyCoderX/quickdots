import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

import "config.js" as Config

PanelText {
    property string format: "ddd MMM dd yyyy hh:mm"
    text: _dateTime

    property string _dateTime
    Timer {
        running: true
        interval: 1000
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            _dateTime = Qt.formatDateTime(new Date(), format)
        }
    }
}
