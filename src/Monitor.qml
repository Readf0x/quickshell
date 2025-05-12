import QtQuick

Rectangle {
  color: Colors.background
  width: 8; height: 26

  property string type
  property double level
  property bool redOnLow: false

  Column {
    spacing: 1
    Item {
      height: 8; width: 8
      Image {
        anchors.centerIn: parent
        source: type && `./img/${type}.png`
      }
    }
    Repeater {
      model: 6
      Rectangle {
        x: 1; width: 6; height: 2
        color: getColor()

        function getColor() {
          if (level <= 15 && redOnLow) { return Colors.red }
          if (index < 6 - level * 6) { return Colors.light_gray }
          return Colors.orange
        }
      }
    }
  }
}

