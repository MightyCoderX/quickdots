import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Notifications
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts

import "../../base"
import "metrics"

import "../../config.js" as Config

RowLayout {
    id: root
    spacing: 5

    Metric {
        id: idleInhibitor
        property bool active: false

        Process {
            id: lockProc
            command: ["systemd-inhibit", "--what=idle", "--who=Quickshell", "--why=UserToggled", "sleep", "infinity"]
        }

        onClicked: {
            active = !active;
            lockProc.running = active
        }

        icon: active ? "" : ""
        displayValue: ""
    }

    Metric {
        id: volume

        PwObjectTracker {
            objects: [Pipewire.defaultAudioSink]
        }

        value: (Pipewire.defaultAudioSink?.audio?.volume ?? 0) * 100

        icons: [ "", "", "" ]
        displayValue: " " + Math.round(value) + "%"

        onScrolledUp: {
            const sink = Pipewire.defaultAudioSink;
            if(sink && sink.audio) {
                sink.audio.volume = Math.min(1.0, sink.audio.volume + 0.01)
            }
        }

        onScrolledDown: {
            const sink = Pipewire.defaultAudioSink;
            if(sink && sink.audio) {
                sink.audio.volume = Math.max(0.0, sink.audio.volume - 0.01)
            }
        }
    }

    Metric {
        id: brightness

        value: 0.0

        icons: [ "󰃞", "󰃟", "󰃠" ]
        displayValue: Math.round(value) + "%"

        // poll brightness every 2 seconds
        Timer {
            interval: 2000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: readProc.running = true
        }

        // Reads current hardware brightness
        Process {
            id: readProc
            command: ["brightnessctl", "info", "-m"]
            stdout: StdioCollector {
                onStreamFinished: {
                    // Output looks like: intel_backlight,backlight,120000,50%,240000
                    let output = text.trim().split(",")
                    if (output.length >= 4) {
                        let pct = output[3].replace("%", "")
                        brightness.value = parseInt(pct)
                    }
                }
            }
        }

        Process {
            id: writeProc
        }

        onScrolledUp: {
            // Optimistic update: instantly update UI so it doesn't wait for the Timer
            value = Math.min(100, value + 1)

            writeProc.command = ["brightnessctl", "set", "1%+"]
            writeProc.running = true
        }

        onScrolledDown: {
            value = Math.max(0, value - 1)

            writeProc.command = ["brightnessctl", "set", "1%-"]
            writeProc.running = true
        }
    }

    Metric {
        id: powerProfile
        value: 0
        displayValue: ""

        property string profile: "balanced"
        readonly property var profiles: ["power-saver", "balanced", "performance"]

        Timer {
            interval: 3000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: ppReadProc.running = true
        }

        Process {
            id: ppReadProc
            command: ["powerprofilesctl", "get"]
            stdout: StdioCollector {
                onStreamFinished: {
                    let output = text.trim()
                    if (output !== "") {
                        powerProfile.profile = output
                    }
                }
            }
        }

        Process {
            id: ppWriteProc
        }

        onClicked: {
            // Find current index, add 1, wrap around to 0
            let currentIndex = powerProfile.profiles.indexOf(powerProfile.profile)
            let nextIndex = (currentIndex + 1) % powerProfile.profiles.length
            let nextProfile = powerProfile.profiles[nextIndex]

            // Optimistic update
            powerProfile.profile = nextProfile

            // Execute shell command
            writeProc.command = ["powerprofilesctl", "set", nextProfile]
            writeProc.running = true
        }

        icon: {
            switch(profile) {
                case "performance": return ""
                case "power-saver": return ""
                case "balanced":
                default: return ""
            }
        }
    }
}
