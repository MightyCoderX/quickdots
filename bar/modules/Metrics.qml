import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Notifications
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts

import "../../base"
import "metrics"
import "metrics/stats"

import "../../config.js" as Config

RowLayout {
    id: metrics
    spacing: 5

    Metric {
        id: cpuUsage
        CpuStats {
            id: cpuStats
        }
        icon: ""
        // displayValue: String(cpuStats.usagePercent).padStart(3, "0") + "%"
        displayValue: cpuStats.usagePercent + "%"
    }

    Metric {
        id: ramUsage
        RamStats {
            id: ramStats
        }
        icon: " "
        // displayValue: String(ramStats.usagePercent).padStart(3, "0") + "%"
        displayValue: ramStats.usagePercent + "%"
    }

    Metric {
        id: gpuUsage
        GpuStats {
            id: gpuStats
        }
        icon: "󰢮"
        // displayValue: String(gpuStats.gpuPercent).padStart(3, "0") + "%"
        displayValue: gpuStats.gpuPercent + "%"
    }

    Metric {
        id: temp
        ThermalStats {
            id: thermalStats
            pollInterval: 1000
        }

        property var icons: ["", "", ""]

        value: thermalStats.tempC

        icon: {
            const intervalSize = 100 / icons.length;

            for(let i = 0; i < icons.length; i++) {
                const start = i*intervalSize;
                const end = start+intervalSize;
                if(value >= start && value <= end) {
                    return icons[i];
                }
            }
        }
        fgColor: value < 90 ? Config.colors.fg : Config.colors.red
        displayValue: value + "°C"
    }

    Metric {
        id: battery
        BatteryStats {
            id: batteryStats
        }

        value: batteryStats.batPercent
        warning: value <= 30
        critical: value <= 20

        property var icons: [" ", " ", " ", " ", " "]
        icon: {
            const intervalSize = 100 / icons.length;

            let icon = "";
            if(batteryStats.batState === UPowerDeviceState.Discharging) {
                for(let i = 0; i < icons.length; i++) {
                    const start = i*intervalSize;
                    const end = start+intervalSize;
                    if(value >= start && value <= end) {
                        icon = icons[i];
                        break;
                    }
                }
            }
            else if(batteryStats.batState === UPowerDeviceState.Charging) {
                icon = "󱐋"
            }
            else if(batteryStats.batState === UPowerDeviceState.FullyCharged) {
                icon = icons[icons.length-1]
            }
            icon
        }
        displayValue: value + "%"
    }
}
