import QtQuick
import "../lib"

Rectangle {
  color: Colors.foreground
  border.color: Colors.foreground
  border.width: 2

  anchors.verticalCenter: parent.verticalCenter
  anchors.verticalCenterOffset: 1

  clip: true

  height: parent.height - 2
  width: childrenRect.width + 4

  Row {
    id: container
    spacing: 2

    width: childrenRect.width
    height: childrenRect.height

    x: 2; y: 2
  }

  default property alias content: container.children
}

