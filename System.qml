pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower
import QtQuick

Singleton {
  property UPowerDevice battery: UPower.devices.values.find(dev=>dev.isLaptopBattery)
  property int temp: Number(temp.text()) / 1000
  property int networkSpeed: 0

  FileView {
    id: temp
    path: Qt.resolvedUrl("/sys/class/thermal/thermal_zone1/temp")
    watchChanges: true
    onFileChanged: {
      this.reload()
    }
  }

  Process {
    id: net
    command: [`/home/readf0x/.config/quickshell/network-usage`, "wlp61s0"]
    running: true
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
    interval: 1000
    running: true
    repeat: true
    onTriggered: net.running = true
  }
}
