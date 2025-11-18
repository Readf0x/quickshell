import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Effects
import "lib"

PanelWindow {
	property string backgroundImage
	property string foregroundImage

	anchors {
		top: true
		bottom: true
		left: true
		right: true
	}
	aboveWindows: false
	exclusionMode: ExclusionMode.Ignore

	Image {
		source: backgroundImage
		anchors.fill: parent
		fillMode: Image.PreserveAspectCrop

		Image {
			source: backgroundImage
			anchors.fill: parent
			fillMode: Image.PreserveAspectCrop
			layer {
				enabled: true
				effect: MultiEffect {
					blurEnabled: true
					blurMax: 12
					blur: 1.0
					maskEnabled: true
					maskSource: timeLayer
				}
			}
		}

		Row {
			width: parent.width
			height: 500

			y: 308

			spacing: 17
			leftPadding: 23

			Repeater {
				model: Cava.bars

				Rectangle {
					width: 28
					height: modelData + 2
					color: Colors.green

					anchors.bottom: parent.bottom
				}
			}
		}

		Item {
			id: timeLayer
			anchors.fill: parent
			layer.enabled: true

			Text {
				id: timeText

				text: Qt.formatDateTime(Time.date, "hh:mm AP").slice(0,5)
				color: "#99FFFFFF"

				renderType: Text.CurveRendering

				font {
					pixelSize: parent.width/6.4
					family: "Cherry Bomb One"
				}

				property int realX: parent.width/42.6
				property int realY: parent.height/8.3
				x:realX;y:realY
			}
		}

		Image {
			id: foreground
			source: foregroundImage
			width: parent.width*1.006
			height: parent.height*1.006
			fillMode: Image.PreserveAspectCrop
			property int realX: -(width - parent.width) / 2
			property int realY: -(height - parent.height) / 2
			x:realX;y:realY
		}
	}

	MouseArea {
		anchors.fill: parent
		hoverEnabled: true
		property int textScale: 400
		property int fgScale: 200

		function paralax(item, scale) {
			item.x = (item.realX+parent.width/(scale*2)) - (mouseX/scale)
			item.y = (item.realY+parent.height/(scale*2)) - (mouseY/scale)
		}

		onPositionChanged: {
			paralax(timeText, textScale)
			paralax(foreground, fgScale)
		}
	}
}

