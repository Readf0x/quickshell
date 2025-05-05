import Quickshell
import QtQuick
import QtQuick.Layouts

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
        }
        Monitor {
          type: "temp"
          level: System.temp
        }
        Monitor {
          type: "battery"
          level: System.battery
        }
      }

      AudioWidget {}

      Clock {}
    }
  }
}
