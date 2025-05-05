import QtQuick

Rectangle {
  color: Colors.background
  border.color: Colors.foreground
  border.width: 2

  anchors.verticalCenter: parent.verticalCenter
  anchors.verticalCenterOffset: 1

  clip: true

  width: 50
  height: parent.height - 2

  Item {
    id: container

    width: parent.width - 4
    height: parent.height - 4

    x: 2; y: 2
  }

  default property alias content: container.children
}

