import Quickshell
import Quickshell.Io
import QtQml

Scope {
    id: root

    property int pollInterval: 2000
    property string thermalZone: "thermal_zone6"

    property int tempC: 0

    Timer {
        interval: pollInterval
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: tempProcess.running = true
    }

    Process {
        id: tempProcess
        command: ["cat", "/sys/class/thermal/" + root.thermalZone + "/temp"]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                let raw = parseInt(this.text.trim(), 10)

                // Fallback to 0 if the read fails or is completely empty
                if (!isNaN(raw)) {
                    root.tempC = Math.round(raw / 1000)
                }
            }
        }
    }
}
