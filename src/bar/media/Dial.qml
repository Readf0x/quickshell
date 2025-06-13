import QtQuick
import "../../lib"

Rectangle {
  id: root

  width: 6
  height: 13
  color: Colors.light_gray

  property var wheelUp: ()=>{}
  property var wheelDown: ()=>{}
  property bool offset: false

  function getColor(index) {
    return (index + offset) % 2 ? Colors.foreground : Colors.light_gray
  }

  MouseArea {
    anchors.fill: parent

    onWheel: (ev) => {
      if (ev.angleDelta.y > 0) {
        root.wheelUp()
      } else if (ev.angleDelta.y < 0) {
        root.wheelDown()
      }
      root.offset = !root.offset
    }
  }

  Column {
    anchors.fill: parent
    anchors.leftMargin: 1
    anchors.rightMargin: 1

    Repeater {
      model: 13
      Rectangle {
        width: 4
        height: 1
        color: getColor(index)
      }
    }
  }

  Rectangle {
    anchors.fill: parent
    opacity: 0.5
    gradient: Gradient {
      GradientStop { position: 0.0; color: Colors.light_gray }
      GradientStop { position: 0.5; color: Colors.foreground }
      GradientStop { position: 1.0; color: Colors.light_gray }
    }
  }
}

