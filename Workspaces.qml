import QtQuick
import Quickshell.Hyprland

Widget {
  width: 86

  Row {
    spacing: 2
    anchors.centerIn: parent

    Repeater {
      model: 10
      
      Rectangle {
        width: 6; height: 22
        color: Hyprland.workspaces.values.find(h => h.id == index + 1) != undefined ? Colors.light_gray : "transparent"

        Rectangle {
          width: 2; height: 22; x: 2
          color: Hyprland.focusedWorkspace?.id == index + 1 ? Colors.foreground : "transparent"
        }
      }
    }
  }
}
