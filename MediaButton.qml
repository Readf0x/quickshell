import QtQuick

Rectangle {
  color: Colors.background
  width: 10; height: 10

  property string type

  MouseArea {
    id: mouse
    anchors.fill: parent
    onClicked: {
      switch (type) {
        case "back": Media.player.previous(); break;
        case "play": Media.player.play(); break;
        case "pause": Media.player.pause(); break;
        case "stop": Media.player.stop(); break;
        case "next": Media.player.next(); break;
      }
    }
  }

  Image {
    id: img
    anchors.centerIn: parent
    source: `./${type}.png`
  }
}

