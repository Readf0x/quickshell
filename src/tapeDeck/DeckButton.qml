import Quickshell.Services.Mpris
import QtQuick
import "../lib"

Rectangle {
  id: root
  width: 30; height: 30

  property int position: 0
  property string type

  readonly property var map: [ 0, 4, -4 ]

  color: "transparent"

  Rectangle {
    color: Colors.light_gray
    width: parent.width; height: parent.height

    property int watchState: mapx()

    y: Media.player.playbackState == watchState ? 2 : 0

    function mapx() {
      switch (type) {
        case "play": return MprisPlaybackState.Playing; break;
        case "pause": return MprisPlaybackState.Paused; break;
        case "stop": return MprisPlaybackState.Stopped; break;
      }
    }

    MouseArea {
      id: mouse
      anchors.fill: parent
      onClicked: {
        switch (type) {
          case "play": Media.player.play(); break;
          case "pause": Media.player.pause(); break;
          case "stop": Media.player.stop(); break;
          case "back": Media.player.previous(); break;
          case "next": Media.player.next(); break;
        }
      }
    }

    Image {
      id: img
      anchors.centerIn: parent
      source: `../img/${type}.png`
    }

    Rectangle {
      y: 27; x: 1 + Math.max(map[position], 0)
      height: 1; width: root.width - 2 - Math.abs(map[position])
      color: "#676461"
    }
  }
}
