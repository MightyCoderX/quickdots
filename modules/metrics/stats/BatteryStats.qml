import Quickshell
import Quickshell.Services.UPower

Scope {
    id: root

    property int batPercent: Math.round(UPower.displayDevice.percentage * 100)
    property int batState: UPower.displayDevice.state
}
