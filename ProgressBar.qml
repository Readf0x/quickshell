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

        color: processColors()

        function processColors() {
          if (progress > 1 && progress <= 2) {
            return segments * (progress - 1) > index ? Colors.red : Colors.orange
          } else if (progress > 2) {
            return segments * (progress - 2) > index ? Colors.blue : Colors.red
          }
          return segments * progress > index ? Colors.orange : Colors.light_gray
        }
      }
    }
  }
}

