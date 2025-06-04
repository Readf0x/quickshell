import QtQuick
import Quickshell.Services.Mpris
import QtQuick.Effects

Row {
  height: 32; width: childrenRect.width
  anchors.horizontalCenter: parent.horizontalCenter
  spacing: 2

  function updateColor() {
    artProcessor.requestPaint()
  }

  function rgbaToHex(r, g, b) {
    const num = (r << 16) + (g << 8) + b;
    return `#${num.toString(16).padStart(6, "0")}`;
  }

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

      Canvas {
        id: artProcessor
        width: 1; height: 1

        property string src: Media.player.trackArtUrl
        onSrcChanged: {
          loadImage(src)
        }

        property color albumColor

        onImageLoaded: {
          requestPaint()
        }

        onPaint: {
          var ctx = getContext("2d")

          console.log(src)
          ctx.drawImage(src, 0,0,1,1)

          let d = ctx.getImageData(0,0,1,1)
          let p = d.data
          albumColor = rgbaToHex(p[0], p[1], p[2])
        }

        visible: false
      }

      Rectangle {
        width: cassette.width
        height: cassette.height
        color: Colors.background

        Rectangle {
          anchors.fill: albumArt
          color: artProcessor.albumColor
        }
        Image {
          id: albumArt
          width: 18
          height: 8
          x: 1
          y: 1
          fillMode: Image.PreserveAspectCrop
          source: Media.player.trackArtUrl
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
          source: "img/cassette.png"
          visible: false
        }
        MultiEffect {
          colorization: 1.0
          colorizationColor: artProcessor.albumColor

          anchors.fill: cassette
          source: cassette
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
          return "No Media"
        }

        width: 119
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
