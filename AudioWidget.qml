import QtQuick

Widget {
  color: Colors.foreground
  width: 70

  Column {
    spacing: 2
    anchors.fill: parent

    Rectangle {
      height: 12; width: 66
      color: Colors.background
      Row {
        Image {
          source: "./output-large.png"
        }
        ProgressBar {
          y: 1; segments: 11
          progress: Audio.sink.audio.volume
        }
      }
    }
    Rectangle {
      height: 12; width: 66
      color: Colors.background
      Row {
        Image {
          source: "./input-large.png"
        }
        ProgressBar {
          y: 1; segments: 11
          progress: Audio.source.audio.volume
        }
      }
    }
  }
}
