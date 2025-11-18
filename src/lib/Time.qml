pragma Singleton

import Quickshell
import QtQuick

Singleton {
	property date date: clock.date
	property int seconds: clock.seconds
	property int hours: clock.hours
	property int minutes: clock.minutes

	SystemClock {
		id: clock
		precision: SystemClock.Seconds
	}
}

