import Quickshell
import Quickshell.Io
import QtQml

Scope {
    id: root

    property int pollInterval: 5000

    property int gpuPercent: 0
    property int vramUsed: 0     // in MB
    property int vramTotal: 0    // in MB
    property int vramPercent: 0

    Timer {
        interval: pollInterval
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: gpuProcess.running = true
    }

    Process {
        id: gpuProcess
        // Query GPU utilization, used VRAM, and total VRAM for the primary card (index 0)
        command: [
            "nvidia-smi",
            "-i", "0",
            "--query-gpu=utilization.gpu,memory.used,memory.total",
            "--format=csv,noheader,nounits"
        ]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                let raw = this.text.trim()
                if (raw === "") return

                let values = raw.split(",").map(val => parseInt(val.trim(), 10))

                root.gpuPercent = values?.[0] || "0"
                root.vramUsed = values?.[1] || "0"
                root.vramTotal = values?.[2] || "0"

                if (root.vramTotal > 0) {
                    root.vramPercent = Math.floor(100 * (root.vramUsed / root.vramTotal))
                }
            }
        }
    }
}
