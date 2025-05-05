import QtQuick

Rectangle {
  color: Colors.background
  width: 8; height: 26

  property string type
  property double level

  Column {
    spacing: 1
    Item {
      height: 8; width: 8
      Image {
        anchors.centerIn: parent
        source: `./${type}.png`
      }
    }
    Repeater {
      model: 6
      Rectangle {
        x: 1; width: 6; height: 2
        color: index < 6 - level * 6 ? Colors.light_gray : Colors.orange
      }
    }
  }
}

