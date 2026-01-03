import Quickshell
import QtQuick
import "panel"
import "volume"
import "notifs"

ShellRoot {
  Panel {
    backgroundImage: "img/background.png"
  }
  Variants {
    model: Quickshell.screens
    delegate: Background {
      required property var modelData
      screen: modelData
      backgroundImage: "img/background.png"
      foregroundImage: "img/foreground.png"
    }
  }
  Notifs {}
  Volume {}
}

