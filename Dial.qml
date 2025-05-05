import QtQuick

Rectangle {
  id: root

  width: 6
  height: 13
  color: Colors.background

  property var wheelUp: ()=>{}
  property var wheelDown: ()=>{}

  MouseArea {
    anchors.fill: parent

    onWheel: (ev) => {
      if (ev.angleDelta.y > 0) {
        root.wheelUp()
      } else if (ev.angleDelta.y < 0) {
        root.wheelDown()
      }
    }
  }

  Column {
    anchors.fill: parent
    anchors.margins: 1
    spacing: 1

    Repeater {
      model: 6
      Rectangle {
        width: 4
        height: 1
        color: Colors.foreground
      }
    }
  }
}

