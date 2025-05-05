import QtQuick

Rectangle {
  id: root

  color: Colors.background
  width: 41; height: 13

  Row {
    anchors.fill: parent
    anchors.margins: 1

    spacing: 1

    Repeater {
      model: 10

      Column {
        width: 3; height: 11
        spacing: 1

        property int bar: index

        Repeater {
          model: 4

          Rectangle {
            width: parent.width
            height: 2

            color: Cava.cava[bar]
          }
        }
      }
    }
  }
}
