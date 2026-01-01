import Quickshell
import Quickshell.Hyprland
import QtQuick
import "../lib"

PanelWindow {
  id: bar

  property string backgroundImage

  anchors {
    left: true
    top: true
    right: true
  }

  readonly property int compact: {
    let workspace = Hyprland.monitorFor(screen).activeWorkspace
    let toplevels = workspace.toplevels.values
    return compactValue(toplevels, workspace, false)
  }
  function compactValue(toplevels, workspace, reloaded): int {
    if (reloaded) {
      if (toplevels.every(t=>t.lastIpcObject.floating)) {
        return 0
      }
      if ((toplevels.filter(t=>!t.lastIpcObject.floating && (t.lastIpcObject.class || t.lastIpcObject.title)) || []).length == 1 || workspace.hasFullscreen) {
        return 2
      }
      return 1
    } else {
      Hyprland.refreshToplevels()
      return compactValue(toplevels, workspace, true)
    }
  }

  GlobalShortcut {
    name: "refreshToplevels"
    onPressed: {
      Hyprland.refreshToplevels()
    }
  }

  color: "transparent"

  mask: Region { item: panelBg }

  implicitHeight: 38
  exclusiveZone: {
    return [
      implicitHeight,
      20,
      16,
    ][compact]
  }

  Item {
    height: bar.implicitHeight - 4
    width: compact == 1 ? parent.width - 8 : parent.width
    clip: false
    anchors {
      top: parent.top
      horizontalCenter: parent.horizontalCenter
      topMargin: compact == 1 ? 4 : 0
      Behavior on topMargin {
        NumberAnimation { duration: 120 }
      }
    }
    Behavior on width {
      NumberAnimation { duration: 120 }
    }
    Rectangle {
      id: panelBg
      height: compact ? 16 : bar.implicitHeight - 4
      width: parent.width
      color: compact ? Colors.background : "transparent"
      Behavior on color {
        ColorAnimation { properties: "color"; duration: 120 }
      }
      radius: compact == 1 ? 4 : 0
    }
    Row {
      anchors {
        left: parent.left
        leftMargin: 4
        top: parent.top
      }
      Workspaces {}
    }

    Media {}

    Row {
      anchors {
        right: parent.right
        top: parent.top
      }
      spacing: 8
      rightPadding: 4
      Calendar {
        anchors {
          top: parent.top
          topMargin: compact ? 4 : 8
        }
        Behavior on anchors.topMargin {
          NumberAnimation { duration: 120 }
        }
      }
      Clock {
        anchors {
          top: parent.top
          topMargin: 4
        }
      }
    }
  }
}

