pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower
import QtQuick

Singleton {
  id: root
  property UPowerDevice battery: UPower.devices.values.find(dev=>dev.isLaptopBattery)
  property int temp: 0
  property int networkSpeed: 0
  property string configPath: Quickshell.env("QS_CONFIG_PATH") || `${Quickshell.env("HOME")}/.config/quickshell`

  Process {
    id: temperature
    command: [`${configPath}/scripts/temperature`]
    running: false
    stdout: SplitParser {
      onRead: data => {
        temp = Number(data) / 1000
      }
    }
  }

  Process {
    id: net
    command: [`${configPath}/scripts/network-usage`]
    running: false
    // stderr: SplitParser {
    //   onRead: data => console.log(data)
    // }
    stdout: SplitParser {
      onRead: data => {
        networkSpeed = Number(data)
      }
    }
  }

  Timer {
    id: timer
    interval: 1000
    running: true
    repeat: true
    onTriggered: {
      net.running = true
      temperature.running = true
    }
  }
}
