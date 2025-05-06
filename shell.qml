import Quickshell
import QtQuick

ShellRoot {
  PanelWindow {
    id: window
    color: "transparent"

    anchors {
      top: true
      left: true
      right: true
    }

    height: 32

    // Left Aligned
    Row {
      height: 32; width: childrenRect.width
      anchors.left: parent.left; anchors.leftMargin: 2
      spacing: 2

      Workspaces {}

      Calendar {}
    }

    // Center Aligned
    MediaController {}

    // Right Aligned
    Row {
      height: 32; width: childrenRect.width
      anchors.right: parent.right; anchors.rightMargin: 2
      spacing: 2

      MonitorContainer {
        Monitor {
          type: "input"
        }
        Monitor {
          type: "network"
          level: System.networkSpeed / 10000
        }
        Monitor {
          type: "temp"
          level: System.temp / 70
        }
        // [TODO] Red battery on low
        Monitor {
          type: System.battery.timeToEmpty == 0 ? "battery-charging" : "battery"
          level: System.battery.percentage
        }
      }

      AudioWidget {}

      Clock {}
    }
  }
}
