import QtQuick
import QtQuick.Layouts
import "../lib"
import "../subclass"

// [TODO] clean up this absolute mess
// this has like 4 instances of recursive rearranging right now...

ColumnLayout {
	id: root
	anchors {
		horizontalCenter: parent.horizontalCenter
		top: parent.top
		topMargin: 3
	}
	width: 190
	height: parent.height - 4
	spacing: 0
	RowLayout {
		id: margin
		Layout.leftMargin: 10
		Layout.rightMargin: 10
		Layout.preferredHeight: root.height
		Layout.maximumHeight: parent.height - 2
		spacing: 3
		clip: true
		Image {
			id: image
			source: "../img/player.svg"
			Layout.maximumHeight: parent.height
			Layout.preferredWidth: parent.height
			Image {
				source: Mpris.player.trackArtUrl
				fillMode: Image.PreserveAspectCrop
				anchors.fill: parent
			}
		}
		ColumnLayout {
			id: text
			Layout.alignment: Qt.AlignBottom
			Layout.bottomMargin: -2
			Layout.preferredWidth: 141
			spacing: -4
			FText {
				id: title
				Layout.fillWidth: true
				text: Mpris.formatted.title
				font.pixelSize: 14
				color: Colors.background
			}
			RowLayout {
				FText {
					id: artist
					text: Mpris.formatted.subtitle
					color: Colors.gray
					z: 6
					font.pixelSize: 10
				}
			}
		}
	}
	Rectangle {
		id: progressBar
		Layout.fillWidth: true
		implicitHeight: 2
		radius: 2
		clip: true
		color: Colors.gray
		Rectangle {
			height: parent.height
			width: parent.width * Mpris.progress
			color: Colors.green
		}
	}

	state: bar.compact ? "compact" : ""

	states: State {
		name: "compact"
		PropertyChanges {
			target: root
			height: 16
			anchors.topMargin: 0
		}
		PropertyChanges {
			target: title
			font.pixelSize: 12
			color: Colors.foreground
		}
		PropertyChanges {
			target: artist
			height: 0
			color: "transparent"
		}
		PropertyChanges {
			target: margin
			Layout.leftMargin: 1
			Layout.rightMargin: 1
			clip: false
		}
		PropertyChanges {
			target: text
			Layout.topMargin: 1
			Layout.bottomMargin: 0
			Layout.preferredHeight: 15
		}
		PropertyChanges {
			target: progressBar
			color: Colors.light
			z: -1
		}
		PropertyChanges {
			target: image
			Layout.bottomMargin: 3
		}
	}

	transitions: Transition {
		NumberAnimation {
			properties: "Layout.topMargin,Layout.bottomMargin,Layout.leftMargin,Layout.rightMargin,height,Layout.preferredHeight,font.pixelSize"
			duration: 120
		}
		ColorAnimation { properties: "color"; duration: 120 }
	}
}

