import QtQuick

Widget {
  width: 70

  Item {
    anchors.right: parent.right
    height: parent.height
    width: 31
    Text {
      anchors.centerIn: parent
      text: dateNum()
      color: Colors.foreground
      function dateNum() {
        let date = Time.date.getDate()
        return `${date < 10 ? '0' : ''}${date}`
      }
      font.family: "Courier20"
    } 
  }

  Item {
    height: parent.height
    width: 37

    Rectangle {
      width: parent.width
      height: 3
      color: Colors.orange
    }

    Grid {
      columns: 7; rows: 5
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.bottom: parent.bottom
      anchors.bottomMargin: 2
      columnSpacing: 2; rowSpacing: 1

      Repeater {
        model: 35
        
        Rectangle {
          width: 3; height: 3

          color: getColor()

          function getColor() {
            let firstDay = new Date(Time.date.getFullYear(), Time.date.getMonth(), 1).getDay()
            if (index >= firstDay &&
                index < new Date(Time.date.getFullYear(), Time.date.getMonth() + 1, 0).getDate() + firstDay) {
              return index == Time.date.getDate() + firstDay - 1 ? Colors.orange : Colors.light_gray
            }
            return "transparent"
          }
        }
      }
    }
  }
}

