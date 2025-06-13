import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Effects
import "../lib"
import "../widgets"

Image {
  source: "../img/dlls.png"

  function checkMedia(p) {
    if (p == null) {
      return true
    }
    return Debug.log(p.playbackState) == MprisPlaybackState.Paused
  }

  Rectangle {
    x: 31; y: 14
    width: max.width; height: max.height

    Image {
      fillMode: Image.PreserveAspectCrop
      source: Media.player.trackArtUrl
      width: 138; height: 61
      x: 4; y: 5
    }

    Image {
      id: max
      source: "../img/mega-cassette.png"
    }
    MultiEffect {
      id: effect
      colorization: 1
      colorizationColor: Media.albumColor
      anchors.fill: max
      source: max
    }

    Image {
      source: "../img/mega-cassette-cover.png"
      anchors.bottom: parent.bottom
      anchors.horizontalCenter: parent.horizontalCenter
    }

    Rectangle {
      x: 30; y: 30
      width: 86; height: 23
      color: Media.albumColor
      radius: 23

      Rectangle {
        x: 2; y: 2
        width: 19; height: 19
        radius: height
        color: Colors.foreground
        Image {
          source: "../img/mega-cassette-wheel.png"
          RotationAnimation on rotation {
            duration: 4000
            loops: Animation.Infinite
            from: 360; to: 0
            paused: checkMedia(Media.player)
          }
        }
      }
      Rectangle {
        x: 66; y: 2
        width: 19; height: 19
        radius: height
        color: Colors.foreground
        Image {
          source: "../img/mega-cassette-wheel.png"
          RotationAnimation on rotation {
            duration: 4000
            loops: Animation.Infinite
            from: 360; to: 0
            paused: checkMedia(Media.player)
          }
        }
      }

      Rectangle {
        x: 27; y: 3
        width: 32; height: 11
        color: "#7FFFF0E7"
        clip: true

        // property int scale: 61
        property int scale: Media.progress * (width * 2 - 3)
        component Smooth: NumberAnimation {
          easing.type: Easing.Linear
          duration: 1000
        }

        Rectangle {
          width: 92 - parent.scale; height: 92 - parent.scale
          y: 8.5 - height / 2
          x: -15.5 - width / 2
          radius: 200
          color: Colors.background
          Behavior on width { Smooth {} }
          Behavior on height { Smooth {} }
        }
        Rectangle {
          width: parent.scale + 32; height: parent.scale + 32
          y: 8 - height / 2
          x: parent.width + 16 - width / 2
          radius: 200
          color: Colors.background
          Behavior on width { Smooth {} }
          Behavior on height { Smooth {} }
        }
      }
    }

    Rectangle {
      width: 5; height: 1
      x: 9; y: 90
      color: Colors.background
    }
    Rectangle {
      width: 5; height: 1
      x: 130; y: 90
      color: Colors.background
    }
  }

  Marquee {
    text: `${Media.player.trackArtist || Media.player.identity} - ${Media.player.trackTitle}`
    width: parent.width - 4
    x: 2; y: 107
  }
}

