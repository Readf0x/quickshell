import QtQuick
import "../lib"

Rectangle {
  color: Colors.background
  border.color: Colors.foreground
  border.width: 2

  anchors.verticalCenter: parent.verticalCenter
  anchors.verticalCenterOffset: 1

  clip: true

  height: parent.height - 2
  width: childrenRect.width + 4

  Item {
    id: container

    width: childrenRect.width
    height: parent.height - 4

    x: 2; y: 2
  }

  default property alias content: container.children
}

