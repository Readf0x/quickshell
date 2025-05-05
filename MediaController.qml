import QtQuick
import Quickshell.Services.Mpris

Row {
  height: 32; width: childrenRect.width
  anchors.horizontalCenter: parent.horizontalCenter
  spacing: 2

  Widget {
    color: Colors.foreground

    Image {
      anchors.centerIn: parent
      source: "./disc1.svg"
      RotationAnimation on rotation {
        id: disc1
        duration: 5000
        loops: Animation.Infinite
        from: 0; to: 360
        paused: Media.player.playbackState == MprisPlaybackState.Paused
      }
    }
  }

  Widget {
    width: 194
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

      Marquee {
        id: mediaText
        y: 1
        text: mediaInfo(Media.player)
        color: Colors.background

        function mediaInfo(p) {
          if (p) {
            return p.trackTitle || p.identity || p.metadata.url || "No Info Listed"
          }
          return "Nothing is playing"
        }

        width: 140
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
        progress: Media.player.position / Media.player.length
      }
    }
  }

  Widget {
    Image {
      anchors.centerIn: parent
      source: "./disc2.svg"
      RotationAnimation on rotation {
        id: disc2
        duration: 7500
        loops: Animation.Infinite
        from: 0; to: 360
        paused: Media.player.playbackState == MprisPlaybackState.Paused
      }
    }
  }
}
