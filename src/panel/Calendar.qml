import QtQuick
import QtQuick.Layouts
import "../lib"
import "../subclass"

Row {
  id: root
  spacing: 4

  readonly property int currentYear: Time.date.getFullYear()
  readonly property int currentMonth: Time.date.getMonth()
  readonly property int currentDate: Time.date.getDate()
  readonly property int daysInMonth: new Date(currentYear, currentMonth + 1, 0).getDate() - 1
  readonly property int firstDay: new Date(currentYear, currentMonth, 1).getDay()
  readonly property int weekRow: Math.floor((currentDate - 1 + firstDay) / 7)
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
      model: root.daysInMonth

      Rectangle {
        readonly property bool today: root.currentDate - 1 == index
        readonly property bool currentWeek: Layout.row == root.weekRow
        Layout.margins: today ? 0 : 1
        Layout.row: Math.floor((index + root.firstDay) / 7)
        Layout.column: (index + root.firstDay) % 7
        width: 2; height: 2
        radius: 2
        scale: today ? 2 : 1
        transformOrigin: Item.Left
        color: today ? Colors.green : (compact ? Colors.light : Colors.gray)
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
  FText {
    id: date
    text: root.currentDate < 10 ? `0${root.currentDate}` : `${root.currentDate}`
    font.pixelSize: 30
    anchors {
      top: parent.top
      topMargin: -6
    }
    color: Colors.background
  }

  state: bar.compact ? "compact" : ""

  states: State {
    name: "compact"
    PropertyChanges {
      target: date
      anchors.topMargin: -7
      font.pixelSize: 18
      color: Colors.foreground
    }
    PropertyChanges {
      target: grid
      anchors.topMargin: root.weekRow * -5 + 2
    }
  }

  transitions: Transition {
    NumberAnimation {
      properties: "anchors.topMargin,font.pixelSize"
      duration: 120
    }
    ColorAnimation { properties: "color"; duration: 120 }
  }
}

