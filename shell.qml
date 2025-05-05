import Quickshell
import QtQuick

ShellRoot {
  PanelWindow {
    id: window
    color: "transparent"

    anchors {
      top: true
      left: true
      right: true
    }

    height: 32

    Widget {
      width: 194
      color: Colors.foreground

      anchors.horizontalCenter: parent.horizontalCenter

      Row {
        spacing: 1

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
          text: Media.player.trackTitle
          color: Colors.background

          width: 140
        }
        
        Equalizer {}
      }
    }
  }
}
