pragma Singleton

import Quickshell
import QtQuick

Singleton {
  readonly property date date: clock.date
  readonly property int seconds: clock.seconds
  readonly property int hours: clock.hours
  readonly property int minutes: clock.minutes

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }
}

