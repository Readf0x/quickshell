pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower
import QtQuick

Singleton {
  id: root
  property UPowerDevice battery: UPower.devices.values.find(dev=>dev.isLaptopBattery)
  property int temp: Number(thermal_zone.text()) / 1000
  property int networkSpeed: 0
  property string user: ""

  FileView {
    id: thermal_zone
    path: Qt.resolvedUrl("/sys/class/thermal/thermal_zone0/temp")
    watchChanges: true
    onFileChanged: {
      this.reload()
    }
  }

  Process {
    id: net
    command: [`/home/${user}/.config/quickshell/network-usage`, "wlp61s0"]
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

  Process {
    command: ["whoami"]
    running: true
    stdout: SplitParser {
      onRead: d => {
        user = d
        net.running = true
        timer.running = true
      }
    }
  }

  Timer {
    id: timer
    interval: 1000
    running: false
    repeat: true
    onTriggered: net.running = true
  }
}
