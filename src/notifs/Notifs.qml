import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import "../lib"
import "../subclass"

PanelWindow {
	id: root

	anchors {
		right: true
		top: true
		bottom: true
	}

	color: "transparent"

	implicitWidth: 248
	exclusiveZone: 0

  mask: Region {
    item: list
  }

	property list<Notification> notifications

	onNotificationsChanged: {
		if (notifications.some(n=>n==null)) {
			notifications = notifications.filter(n=>n!=null)
		}
	}

	NotificationServer {
		id: server

		actionsSupported: true
		bodyHyperlinksSupported: true
		bodyMarkupSupported: true
		imageSupported: true
		persistenceSupported: true

		onNotification: notif => {
			notif.tracked = true
			root.notifications = [notif, ...root.notifications]
		}
	}

	Column {
    id: list
		spacing: 4

		anchors {
			top: parent.top
			right: parent.right
			left: parent.left
			margins: 4
		}

		Repeater {
			id: repeater
			model: root.notifications

			Rectangle {
				required property Notification modelData
				width: 240
				height: notifVertical.height
				color: Colors.accent
				radius: 4
				Column {
					id: notifVertical
					width: 230
					anchors.centerIn: parent
					topPadding: 3
					bottomPadding: 3

					Item {
						height: 16
						width: parent.width
						IconImage {
							implicitSize: 16
							source: Quickshell.iconPath(modelData.appIcon)
						}
						FText {
							anchors.centerIn: parent
							text: modelData.summary
							font.pixelSize: 16
							width: Math.min(190, implicitWidth)
						}
						IconImage {
							anchors {
								right: parent.right
							}
							source: Quickshell.iconPath("dialog-close")
							implicitSize: 16
							MouseArea {
								id: area
								hoverEnabled: true
								anchors.fill: parent
								property color propogatedColor: "transparent"
								acceptedButtons: Qt.LeftButton
								onClicked: {
									let thisNotif = modelData
									root.notifications = root.notifications.filter(n=>n.id!=thisNotif.id)
									thisNotif.dismiss()
								}
							}
							Rectangle {
								color: area.containsMouse ? area.pressed ? Colors.gray : Colors.tgray : "transparent"
								anchors.fill: parent
							}
						}
					}

					RowLayout {
						width: parent.width
						Image {
							source: modelData.image
							visible: source != ""
							Layout.preferredHeight: 30
              Layout.preferredWidth: Math.min(60,
                (sourceSize.width / sourceSize.height) * Layout.preferredHeight)
						}
						FText {
							textFormat: Text.StyledText
							Layout.fillWidth: true

							text: modelData.body
							font.pixelSize: 14
							wrapMode: Text.Wrap
							maximumLineCount: 3
						}
					}
				}
			}
		}
	}
}

