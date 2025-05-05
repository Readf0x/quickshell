pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
  property double battery: Number(battery.text()) / 100
  property double temp: Number(temp.text()) / 100000

  FileView {
    id: battery
    path: Qt.resolvedUrl("/sys/class/power_supply/BAT0/capacity")
    watchChanges: true
    onFileChanged: {
      this.reload()
    }
  }
  FileView {
    id: temp
    path: Qt.resolvedUrl("/sys/class/thermal/thermal_zone1/temp")
    watchChanges: true
    onFileChanged: {
      this.reload()
    }
  }
}
