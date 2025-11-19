import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Effects
import "../lib"

PanelWindow {
	id: bar

	property string backgroundImage

  anchors {
    left: true
    top: true
    right: true
  }

	readonly property bool compact: {
		let toplevels = Hyprland.monitorFor(screen).activeWorkspace.toplevels.values
		return !toplevels.every(t=>t.lastIpcObject.floating)
	}

	GlobalShortcut {
		name: "refreshToplevels"
		onPressed: {
			Hyprland.refreshToplevels()
		}
	}

	color: "transparent"

	// Image {
	// 	id: panelBg
	// 	source: "../img/background.png"
	// 	height: 16
	// 	width: parent.width
	// 	opacity: bar.compact ? 1 : 0
	// 	layer {
	// 		enabled: true
	// 		effect: MultiEffect {
	// 			autoPaddingEnabled: false
	// 			blurEnabled: true
	// 			blur: 1.0
	// 			blurMultiplier: 50
	// 		}
	// 	}
	//
	// 	Behavior on opacity {
	// 		NumberAnimation {
	// 			duration: 150
	// 			easing.type: Easing.InOutQuad
	// 		}
	// 	}
	// }
	Rectangle {
		id: panelBg
		// color: Colors.black
		color: "transparent"
		height: 16
		width: parent.width
		// opacity: bar.compact ? 1 : 0
		// Behavior on opacity {
		// 	NumberAnimation {
		// 		duration: 150
		// 		easing.type: Easing.InOutQuad
		// 	}
		// }
	}

	mask: Region { item: panelBg }

	implicitHeight: 34
	exclusiveZone: compact ? 16 : implicitHeight

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

