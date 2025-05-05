import QtQuick

Widget {
  width: 33

  Grid {
    columns: 7; rows: 5
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 1
    columnSpacing: 1; rowSpacing: 1

    Repeater {
      model: 35
      
      Rectangle {
        width: 3; height: 3

        color: getColor()

        function getColor() {
          let firstDay = new Date(Time.date.getFullYear(), Time.date.getMonth(), 1).getDay()
          if (index >= firstDay &&
              index < new Date(Time.date.getFullYear(), Time.date.getMonth() + 1, 0).getDate() + firstDay) {
            return index == Time.date.getDate() + firstDay - 1 ? Colors.foreground : Colors.light_gray
          }
          return "transparent"
        }
      }
    }
  }
}

