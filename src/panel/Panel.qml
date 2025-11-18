import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "../lib"

PanelWindow {
	id: bar

  anchors {
    left: true
    top: true
    right: true
  }

	readonly property bool compact: {
		let toplevels = Hyprland.monitorFor(screen).activeWorkspace.toplevels.values
		return !toplevels.every(t=>t.lastIpcObject.floating)
	}

	IpcHandler {
		target: "bar"

		function refresh(): void {
			Hyprland.refreshToplevels()
		}
	}

	color: "transparent"

	implicitHeight: 34
	exclusiveZone: 16

	Row {
		anchors {
			left: parent.left
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
				topMargin: 4
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

