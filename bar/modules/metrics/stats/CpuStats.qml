import Quickshell.Io
import Quickshell
import QtQml

Scope {
    id: root

    property int pollInterval: 5000

    property string _lastStats: ""
    property bool _primed: false

    property int usagePercent: 0

    Timer {
        id: pollTimer
        interval: root._primed ? pollInterval : 500
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: cpuProcess.running = true
    }

    Process {
        id: cpuProcess
        command: ["grep", "^cpu ", "/proc/stat"]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                let currentLine = this.text.trim()

                if (root._lastStats !== "") {
                    root.usagePercent = cpuProcess.calculateCpuUsagePercent(root._lastStats, currentLine)
                    root._primed = true;
                }

                root._lastStats = currentLine
            }
        }

        function calculateCpuUsagePercent(line1, line2) {
            let stats1 = line1.split(/\s+/).slice(1).map(Number)
            let stats2 = line2.split(/\s+/).slice(1).map(Number)

            let idle1 = stats1[3] + stats1[4]
            let idle2 = stats2[3] + stats2[4]

            let total1 = stats1.reduce((a, b) => a + b, 0)
            let total2 = stats2.reduce((a, b) => a + b, 0)

            let totalDiff = total2 - total1
            let idleDiff = idle2 - idle1

            return Math.floor(100 * (1 - (idleDiff / totalDiff)))
        }
    }
}
