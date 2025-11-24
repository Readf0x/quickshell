import QtQuick
import QtQuick.Shapes
import "../lib"

Item {
	id: root
	width: 50; height: 30
	Image {
		id: face
		anchors {
			fill: parent
			centerIn: parent
		}
		source: "../img/clockface.svg"
	}
	Image {
		id: faceCompact
		anchors {
			fill: parent
			centerIn: parent
		}
		opacity: 0
		source: "../img/clockface-compact.svg"
	}
	Shape {
		id: hands
		anchors {
			fill: parent
			centerIn: parent
		}

		layer {
			enabled: true
			samples: 4
		}

		function percentToPoint(percent: real, radius: int): list<int> {
			let theta = (2 * Math.PI * percent) - (Math.PI/2)
			return [ Math.round(radius * Math.cos(theta)), Math.round(radius * Math.sin(theta)) ]
		}

		ShapePath {
			id: second
			strokeColor: Colors.green
			strokeWidth: 1

			startX: 25; startY: 15

			property int length: 14

			PathLine {
				property list<int> point: hands.percentToPoint(Time.seconds / 60, second.length)
				x: point[0] + second.startX
				y: point[1] + second.startY
			}
		}
		ShapePath {
			id: minute
			strokeColor: Colors.background
			strokeWidth: 3
			capStyle: ShapePath.RoundCap

			startX: 25; startY: 15

			property int length: 12

			PathLine {
				property list<int> point: hands.percentToPoint(Time.minutes / 60, minute.length)
				x: point[0] + minute.startX
				y: point[1] + minute.startY
			}
		}
		ShapePath {
			id: hour
			strokeColor: Colors.background
			strokeWidth: 3
			capStyle: ShapePath.RoundCap

			startX: 25; startY: 15

			property int length: 7

			PathLine {
				property list<int> point: hands.percentToPoint((Time.hours + Time.minutes/60) / 12, hour.length)
				x: point[0] + hour.startX
				y: point[1] + hour.startY
			}
		}
	}

	state: bar.compact ? "compact" : ""

	states: State {
		name: "compact"
		PropertyChanges {
			target: hour
			strokeWidth: 2
			length: 3
			startX: 15; startY: 8
			strokeColor: Colors.foreground
		}
		PropertyChanges {
			target: minute
			strokeWidth: 2
			length: 6
			startX: 15; startY: 8
			strokeColor: Colors.foreground
		}
		PropertyChanges {
			target: second
			length: 8
			startX: 15; startY: 8
		}
		PropertyChanges {
			target: root
			width: 30; height: 16
			anchors {
				rightMargin: 2
				topMargin: 0
			}
		}
		PropertyChanges {
			target: face
			opacity: 0
		}
		PropertyChanges {
			target: faceCompact
			opacity: 1
		}
	}

	transitions: Transition {
		NumberAnimation {
			properties: "strokeWidth,length,x,y,width,height,startX,startY,opacity"
			duration: 120
		}
		ColorAnimation { properties: "strokeColor"; duration: 120 }
	}
}

