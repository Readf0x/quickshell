import QtQuick
import QtQuick.Layouts

Rectangle {
  id: root

  color: Colors.background
  width: 41; height: 13

  GridLayout {
    rows: 4; columns: 10
    rowSpacing: 1; columnSpacing: 1
    uniformCellWidths: true; uniformCellHeights: true
    width: 39; height: 11
    anchors.centerIn: parent

    Repeater {
      model: 4

      Repeater {
        model: 10

        property int row: index

        Column {
          width: 3
          // height: Cava.heights[index][row]
          height: 2
          Rectangle {
            width: 3; height: 1
            color: Cava.colors[index][row][0]
          }
          Rectangle {
            width: 3; height: 1
            color: Cava.colors[index][row][1]
          }
        }
      }
    }
  }
}
