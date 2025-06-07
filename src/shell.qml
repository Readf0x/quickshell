//@ pragma UseQApplication
import Quickshell
import QtQuick

ShellRoot {
  PanelWindow {
    id: root
    color: Debug.loadDebugBecauseQuickshellHasSuperLazySingletonEvaluationAndTheIpcHandlerDoesntAppearOtherwise("transparent")

    anchors {
      top: true
      left: true
      right: true
    }

    height: 32

    // Left Aligned
    Row {
      id: right

      height: 32; width: childrenRect.width
      anchors.left: parent.left; anchors.leftMargin: 2
      spacing: 2

      Workspaces {}

      Tray {}
    }

    Rectangle {
      color: Colors.foreground
      anchors.left: right.right
      anchors.right: middle.left
      y: 16
      anchors.margins: 4

      height: 2
    }

    // Center Aligned
    MediaController {
      id: middle
    }

    Rectangle {
      color: Colors.foreground
      anchors.left: middle.right
      anchors.right: left.left
      y: 16
      anchors.margins: 4

      height: 2
    }

    // Right Aligned
    Row {
      id: left

      height: 32; width: childrenRect.width
      anchors.right: parent.right; anchors.rightMargin: 2
      spacing: 2

      MonitorContainer {
        Monitor {
          type: "network"
          level: System.networkSpeed / 10000
        }
        Monitor {
          type: "temp"
          level: System.temp / 100
        }
        // [TODO] Red battery on low
        Loader {
          active: System.battery != null
          sourceComponent: Monitor {
            type: System.battery?.timeToEmpty == 0 ? "battery-charging" : "battery"
            level: System.battery?.percentage || 0
          }
        }
      }

      AudioWidget {}

      Calendar {}

      Clock {}
    }
  }
}
