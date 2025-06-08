import QtQuick
import "../lib"
import "../widgets"

Widget {
  color: Colors.foreground
  width: 66

  Column {
    spacing: 2
    anchors.fill: parent

    Rectangle {
      height: 12; width: 62
      color: Colors.background
      Row {
        Image {
          source: Audio.sink?.audio.muted ? "../img/output-muted-large.png" : "../img/output-large.png"
        }
        ProgressBar {
          y: 1; segments: 10
          progress: Audio.sink?.audio.volume.toFixed(2) || 0
        }
      }
    }
    Rectangle {
      height: 12; width: 62
      color: Colors.background
      Row {
        Image {
          source: Audio.source?.audio.muted ? "../img/input-muted-large.png" : "../img/input-large.png"
        }
        ProgressBar {
          y: 1; segments: 10
          progress: Audio.source?.audio.volume.toFixed(2) || 0
        }
      }
    }
  }
}
