import QtQuick
import QtQuick.Layouts
import "../lib"

Row {
	spacing: 4
	GridLayout {
		id: grid
		anchors {
			top: parent.top
			topMargin: 0
		}
		rows: 5
		columns: 7
		rowSpacing: 1
		columnSpacing: 1
		uniformCellHeights: true
		uniformCellWidths: true
		Repeater {
			id: repeater
			model: new Date(Time.date.getFullYear(), Time.date.getMonth() + 1, 0).getDate()-1
			readonly property int firstDay: new Date(Time.date.getFullYear(), Time.date.getMonth(), 1).getDay()
			readonly property int weekRow: Math.floor((Time.date.getDate() - 1 + firstDay) / 7)

			Rectangle {
				readonly property bool today: Time.date.getDate()-1 == index
				readonly property bool currentWeek: Layout.row == repeater.weekRow
				Layout.margins: today ? 0 : 1
				Layout.row: Math.floor((index + repeater.firstDay) / 7)
				Layout.column: (index + repeater.firstDay) % 7
				width: today ? 4 : 2
				height: width
				radius: 2
				color: today ? Colors.green : Colors.gray
				opacity: {
					if (bar.compact) {
						return currentWeek ? 1.0 : 0.0
					}
					return 1.0
				}

				Behavior on opacity {
					NumberAnimation {
						duration: 150
						easing.type: Easing.InOutQuad
					}
				}
			}
		}
	}
	Text {
		id: date
		text: {
			let date = Time.date.getDate()
			return `${date < 10 ? '0' : ''}${date}`
		}
		font {
			pixelSize: 30
			family: "Sniglet"
		}
		anchors {
			top: parent.top
			topMargin: -6
		}
	}

	state: bar.compact ? "compact" : ""

	states: State {
		name: "compact"
		PropertyChanges {
			target: date
			anchors.topMargin: -7
			font.pixelSize: 18
		}
		PropertyChanges {
			target: grid
			anchors.topMargin: repeater.weekRow * -5 + 2
		}
	}

	transitions: Transition {
		NumberAnimation {
			properties: "anchors.topMargin,font.pixelSize"
			duration: 120
		}
	}
}

