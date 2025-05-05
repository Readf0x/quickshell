pragma Singleton

import Quickshell
import QtQuick

Singleton {
  property var date: new Date()

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: date = new Date()
  }
}

