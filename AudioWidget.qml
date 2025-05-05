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
          source: Audio.sink.audio.muted ? "./output-muted-large.png" : "./output-large.png"
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
          source: Audio.source.audio.muted ? "./input-muted-large.png" : "./input-large.png"
        }
        ProgressBar {
          y: 1; segments: 11
          progress: Audio.source.audio.volume
        }
      }
    }
  }
}
