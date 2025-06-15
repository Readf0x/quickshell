import QtQuick
import Quickshell
import Quickshell.Services.Mpris
import QtQuick.Effects
import "../../lib"
import "../../widgets"

Row {
  id: root
  property PopupWindow popupRef

  height: 32; width: childrenRect.width
  anchors.horizontalCenter: parent.horizontalCenter
  spacing: 2

  function checkMedia(p) {
    if (p == null) {
      return true
    }
    return p.playbackState == MprisPlaybackState.Paused
  }

  Widget {
    Rectangle {
      width: disc1.width
      height: disc1.height
      color: Colors.light_gray
      radius: 180
      anchors.centerIn: parent
    }
    Image {
      id: disc1
      anchors.centerIn: parent
      source: "../../img/disc1.svg"
      RotationAnimation on rotation {
        id: disc1Rot
        duration: 5000
        loops: Animation.Infinite
        from: 0; to: 360
        paused: checkMedia(Media.player)
      }
    }
  }

  Widget {
    width: 195
    color: Colors.background

    Row {
      padding: 1
      spacing: 1
      height: 13

      Dial {
        wheelUp: () => {
          Media.nextPlayer()
        }
        wheelDown: () => {
          Media.nextPlayer(false)
        }
      }

      Rectangle {
        width: cassette.width
        height: cassette.height
        color: Colors.background

        property bool showCassette: isMedia(Media.player) && Media.url != ""
        function isMedia(p) {
          if (p != null && p.trackArtUrl != null) { return true }
          else { return false }
        }

        Rectangle {
          anchors.fill: albumArt
          color: Media.albumColor
          visible: parent.showCassette
        }
        Image {
          id: albumArt
          width: 18
          height: 8
          x: 1
          y: 1
          fillMode: Image.PreserveAspectCrop
          source: Media.url
          visible: parent.showCassette
        }

        Rectangle {
          color: Colors.foreground
          width: 2; height: 2
          x: 5; y: 5
        }
        Rectangle {
          color: Colors.foreground
          width: 2; height: 2
          x: 13; y: 5
        }

        Image {
          id: cassette
          source: "../../img/cassette.png" 
          visible: false
        }
        Image {
          id: cassetteEmpty
          source: "../../img/cassette-empty.png"
          visible: !parent.showCassette
        }
        MultiEffect {
          colorization: 1.0
          colorizationColor: Media.albumColor

          anchors.fill: cassette
          source: cassette
          visible: parent.showCassette
        }

        MouseArea {
          anchors.fill: parent
          onClicked: popupRef.visible = !popupRef.visible
        }
      }

      Marquee {
        id: mediaText
        y: 1
        text: mediaInfo(Media.player)
        color: Colors.foreground

        function mediaInfo(p) {
          if (p) {
            return p.trackTitle || p.identity || p.metadata.url || "No Info Listed"
          }
          return "No Media"
        }

        width: 119
      }
      
      Equalizer {}
    }

    Row {
      x: 1; y: 15
      height: 10
      spacing: 2

      MediaButton { type: "play";  }
      MediaButton { type: "pause"; }
      MediaButton { type: "stop";  }
      MediaButton { type: "back";  }
      MediaButton { type: "next";  }

      ProgressBar {
        segments: 26
        progress: Media.player.positionSupported ? Media.progress : 0
      }
    }
  }

  Widget {
    Rectangle {
      width: 22
      height: 22
      color: Colors.foreground
      radius: 180
      anchors.centerIn: parent
    }
    Image {
      id: disc2
      anchors.centerIn: parent
      source: "../../img/disc2.svg"
      RotationAnimation on rotation {
        id: disc2Rot
        duration: 7500
        loops: Animation.Infinite
        from: 0; to: 360
        paused: checkMedia(Media.player)
      }
    }
  }
}
