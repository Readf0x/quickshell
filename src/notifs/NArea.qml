import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications
import QtQuick
import "../lib"
import "../widgets"

PopupWindow {
	id: narea
	anchor {
		window: root
		rect {
			x: root.width - 2
			y: root.height + 2
		}
		edges: Edges.Left | Edges.Top
		gravity: Edges.Left | Edges.Bottom
		adjustment: PopupAdjustment.None
	}

	visible: false

	// width: 340
	// height: 80
	implicitWidth: 336
	implicitHeight: root.screen.height - root.height - 4

	Widget {
		anchors.fill: parent

		color: Colors.shading

		ListView {
			model: notifs

			delegate: Rectangle {
				width: 10
				height: 10
				color: "red"
			}
		}
	}

	NotificationServer {
		onNotification: n => {
			listView.notifs.push(n)
		}
	}

	IpcHandler {
		target: "notifs"

		function toggleVisible(): void { narea.visible = !narea.visible }
	}
}

