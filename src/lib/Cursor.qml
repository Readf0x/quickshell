pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick

Singleton {
  property var cursorpos: { return { x: 0, y: 0 }}

  Timer {
    id: timerComponent
    interval: 20; running: true; repeat: true
    onTriggered: {
      if (!Hyprland.focusedWorkspace.hasFullscreen) proc.running = true
    }
  }

  Process {
    id: proc
    command: [ "hyprctl", "cursorpos", "-j" ]

    stdout: StdioCollector {
      onStreamFinished: {
        cursorpos = JSON.parse(text)
      }
    }
  }
}

