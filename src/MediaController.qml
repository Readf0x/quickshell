import QtQuick
import Quickshell.Services.Mpris

Row {
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
    color: Colors.foreground

    Rectangle {
      width: disc1.width
      height: disc1.height
      color: Colors.background
      radius: 180
      anchors.centerIn: parent
    }
    Image {
      id: disc1
      anchors.centerIn: parent
      source: "./img/disc1.svg"
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
    width: 193
    color: Colors.foreground

    Row {
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

      Image {
        id: albumArt
        height: 13
        fillMode: Image.PreserveAspectFit
        source: Media.player.trackArtUrl
      }

      Marquee {
        id: mediaText
        y: 1
        text: mediaInfo(Media.player)
        color: Colors.background

        function mediaInfo(p) {
          if (p) {
            return p.trackTitle || p.identity || p.metadata.url || "No Info Listed"
          }
          return "No Media"
        }

        width: 140 - albumArt.width - (albumArt.width ? 1 : 0)
      }
      
      Equalizer {}
    }

    Row {
      anchors.bottom: parent.bottom
      height: 10
      spacing: 2

      MediaButton { type: "back";  }
      MediaButton { type: "play";  }
      MediaButton { type: "pause"; }
      MediaButton { type: "stop";  }
      MediaButton { type: "next";  }

      ProgressBar {
        segments: 26
        progress: Media.player?.position / Media.player?.length
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
      source: "./img/disc2.svg"
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
