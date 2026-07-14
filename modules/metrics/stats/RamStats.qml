import Quickshell.Io
import Quickshell
import QtQml

Scope {
    id: root

    property int pollInterval: 5000

    property int usagePercent: 0

    Timer {
        interval: root._primed ? pollInterval : 500
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: ramProcess.running = true
    }

    Process {
        id: ramProcess
        command: ["awk", "/^Mem(Total|Available)/ {print $2}", "/proc/meminfo"]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                const data = this.text.trim().split("\n");
                let [total, avail] = data.map(Number);

                if (data.length === 2 && total > 0) {
                    root.usagePercent = Math.floor(100 * (1 - (avail / total)))
                }
            }
        }
    }
}
