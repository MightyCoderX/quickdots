import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Notifications
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts
import Quickshell.Networking
import Quickshell.Bluetooth

import "../../base"
import "metrics"

import "../../config.js" as Config

RowLayout {
    id: root
    spacing: 5

    Metric {
        id: bluetoothWidget

        property var adapter: Bluetooth.defaultAdapter
        property var device: null

        function initBluetooth() {
            if(!Bluetooth || !adapter) return;

            const devices = adapter.devices.values;

            if (devices.length === 0) return;
            btInitTimer.running = false;

            bluetoothWidget.device = devices
                .filter(d => d.trusted)[0];
        }

        Timer {
            id: btInitTimer
            interval: 1000
            repeat: true
            running: true
            onTriggered: bluetoothWidget.initBluetooth()
        }

        icon: adapter?.state === BluetoothAdapterState.Enabled ? "󰂯" : "󰂲"
        displayValue: {
            if(!device) return "";
            if(device.connected) {
                return device?.name + " " + Math.round(device.battery * 100) + "%";
            }

            return "";
        }
        onClicked: {
            if(!device) return;
            if(device.connected) {
                device.disconnect();
            }
            else {
                device.connect();
            }
        }
    }

    Metric {
        id: networkWidget
        property var device: null
        property var network: null
        property string netName: network?.nmSettings?.[0]?.id ?? "none"

        function initNetwork() {
            if(!Networking) return

            const devices = Networking.devices.values;

            if (devices.length === 0) return;
            initTimer.running = false

            for(const d of devices) {
                if(d.state === ConnectionState.Connected) {
                    networkWidget.device = d
                    networkWidget.network = d.network
                    break;
                }
            }
        }

        Timer {
            id: initTimer
            interval: 1000
            repeat: true
            running: true
            onTriggered: networkWidget.initNetwork()
        }

        icon: {
            if(!device) {
                networkWidget.critical = true;
                return "󰲛"
            }
            networkWidget.critical = false;
            switch(device.type) {
                case DeviceType.Wifi: return ""
                case DeviceType.Wired: return ""
            }
        }

        displayValue: netName ? " " + netName : ""
    }
}
