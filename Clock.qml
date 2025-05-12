import QtQuick

Widget {
  width: 44
  Image {
    source: "./img/markers.png"
    anchors.centerIn: parent
  }
  Item {
    anchors.centerIn: parent
    width: 1; height: 24

    Rectangle {
      width: 1; height: 12
      color: Colors.red
    }

    rotation: Time.date.getSeconds() * 6
  }
  Item {
    anchors.centerIn: parent
    width: 2; height: 24

    Rectangle {
      width: 2; height: 12
      color: Colors.foreground
    }

    rotation: Time.date.getMinutes() * 6
  }
  Item {
    anchors.centerIn: parent
    width: 2; height: 18

    Rectangle {
      width: 2; height: 9
      color: Colors.foreground
    }

    rotation: (Time.date.getHours() + Time.date.getMinutes() / 60) * 30
  }
}
