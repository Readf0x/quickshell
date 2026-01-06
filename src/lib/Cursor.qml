pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick

Singleton {
  property point cursorpos: Qt.point(0, 0)
  property bool _lastFullscreen: false
  property bool _wasActive: false

  Timer {
    id: updateTimer
    interval: 16 // ~60fps for smooth parallax
    running: false
    repeat: true
    onTriggered: {
      if (!Hyprland.focusedWorkspace.hasFullscreen && Hyprland.focusedWorkspace.active) {
        proc.running = true
      }
    }
  }

  Connections {
    target: Hyprland.focusedWorkspace
    function onHasFullscreenChanged() {
      const hasFullscreen = Hyprland.focusedWorkspace.hasFullscreen
      if (hasFullscreen !== _lastFullscreen) {
        _lastFullscreen = hasFullscreen
        if (!hasFullscreen && Hyprland.focusedWorkspace.active) {
          updateTimer.running = true
        } else {
          updateTimer.running = false
        }
      }
    }
    function onActiveChanged() {
      const isActive = Hyprland.focusedWorkspace.active
      if (isActive !== _wasActive) {
        _wasActive = isActive
        if (isActive && !Hyprland.focusedWorkspace.hasFullscreen) {
          updateTimer.running = true
        } else {
          updateTimer.running = false
        }
      }
    }
  }

  Process {
    id: proc
    command: [ "hyprctl", "cursorpos", "-j" ]

    stdout: StdioCollector {
      onStreamFinished: {
        const newPos = JSON.parse(text)
        cursorpos = Qt.point(newPos.x, newPos.y)
      }
    }
  }

  Component.onCompleted: {
    _lastFullscreen = Hyprland.focusedWorkspace.hasFullscreen
    _wasActive = Hyprland.focusedWorkspace.active
    if (!_lastFullscreen && _wasActive) {
      updateTimer.running = true
    }
  }
}

