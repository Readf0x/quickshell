import QtQuick

Rectangle {
  color: Colors.background
  height: 10
  width: segments * 5 - 1

  property int segments: 10
  property double progress: 0.0

  MouseArea {
    anchors.fill: parent


  }

  Row {
    spacing: 1
    height: parent.height

    Repeater {
      id: repeater
      model: segments

      Rectangle {
        width: 4
        height: parent.height

        color: segments * progress > index ? Colors.orange : Colors.light_gray
      }
    }
  }
}

