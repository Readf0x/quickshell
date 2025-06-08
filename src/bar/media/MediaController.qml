import QtQuick
import Quickshell.Services.Mpris
import QtQuick.Effects
import "../../lib"
import "../../widgets"

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
        width: 4; height: 4

        property string src: Media.player.trackArtUrl
        onSrcChanged: {
          if (isImageLoaded(src)) {
            requestPaint()
          } else {
            loadImage(src)
          }
        }

        function chunkIntoFours(arr) {
          const result = []
          for (let i = 0; i < arr.length; i += 4) {
            result.push([arr[i],arr[i+1],arr[i+2],arr[i+3]])
          }
          return result
        }

        function highestSaturation(data) {
          const chunked = chunkIntoFours(data)
          let sat = chunked.map(arr => {
            const norm = arr.map(i=>i/255)
            let max = Math.max(norm[0], norm[1], norm[2])
            let min = Math.min(norm[0], norm[1], norm[2])
            let l = (max + min) / 2

            let s
            if (max === min) { s = 0 }
            else {
              let d = max - min
              s = l > 0.5 ? d / (2 - max - min) : d / (max + min)
            }

            return s
          })

          let i = sat.indexOf(Math.max(...sat))
          return chunked[i]
        }

        property color albumColor
        onAlbumColorChanged: Media.albumColor = albumColor

        onImageLoaded: {
          requestPaint()
        }

        onPaint: {
          if (!isImageLoaded(src)) return

          var ctx = getContext("2d")

          ctx.drawImage(src, 0,0,4,4)

          let d = ctx.getImageData(0,0,4,4)
          let p = highestSaturation(d.data)
          albumColor = rgbaToHex(p[0],p[1],p[2])
        }

        visible: false
      }

      Rectangle {
        width: cassette.width
        height: cassette.height
        color: Colors.background

        property bool showCassette: isMedia(Media.player) && albumArt.albumColor != "#000000"
        function isMedia(p) {
          if (p != null && p.trackArtUrl != null) { return true }
          else { return false }
        }

        Rectangle {
          anchors.fill: albumArt
          color: artProcessor.albumColor
          visible: parent.showCassette
        }
        Image {
          id: albumArt
          width: 18
          height: 8
          x: 1
          y: 1
          fillMode: Image.PreserveAspectCrop
          source: Media.player.trackArtUrl
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
          colorizationColor: artProcessor.albumColor

          anchors.fill: cassette
          source: cassette
          visible: parent.showCassette
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
