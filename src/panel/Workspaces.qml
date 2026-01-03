import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "../lib"

RowLayout {
  id: root

  height: 34
  spacing: 2

  Behavior on implicitHeight {
    NumberAnimation {
      duration: 120
    }
  }

  Repeater {
    id: repeater
    model: 10
    property int activeHeight: 20
    property int focusedHeight: 26

    Rectangle {
      color: data.color
      implicitHeight: data.height
      width: 4
      radius: 2
      border {
        color: data.border
        width: color != "transparent" ? 1 : 0
      }

      property var data: {
        const workspace = Hyprland.workspaces.values.find(w => w.id == modelData + 1)
        if (workspace) {
          if (Hyprland.focusedWorkspace?.id == modelData + 1) {
            return { color: Colors.green, height: repeater.focusedHeight, border: "transparent" }
          }
          if (workspace.active) {
            return { color: bar.compact ? Colors.foreground : Colors.background, height: repeater.activeHeight, border: "transparent" }
          }
          return { color: bar.compact ? Colors.light : Colors.gray, height: 4, border: "transparent" }
        }
        return { color: "transparent", height: 4, border: bar.compact ? Colors.tlight : Colors.tgray }
      }

      Behavior on implicitHeight {
        NumberAnimation {
          duration: 500
          easing.type: Easing.OutBack
        }
      }

      Behavior on color {
        ColorAnimation {
          duration: 150
          easing.type: Easing.InOutQuad
        }
      }
    }
  }

  state: bar.compact ? "compact" : ""

  states: State {
    name: "compact"
    PropertyChanges {
      target: root
      height: 16
      y: 0
    }
    PropertyChanges {
      target: repeater
      activeHeight: 8
      focusedHeight: 14
    }
  }
}

