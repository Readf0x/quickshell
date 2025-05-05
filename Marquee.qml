import QtQuick

Item {
  id: marqueeText
  height: scrollingText.height
  clip: true

  property int tempX: 0
  property alias text: scrollingText.text
  property alias color: scrollingText.color

  onTextChanged: {
    scrollingText.x = 0
    tempX = 0
    if (scrollingText.width > marqueeText.width) {
      timer.running = false
      timer.direction = false
      pauseTimer.running = true
    }
  }

  Text {
    x: marqueeText.tempX
    id: scrollingText

    color: Colors.foreground

    font.family: "Courier"
    font.pointSize: 11
  }

  Timer {
    id: timer
    interval: 200
    running: scrollingText.width > marqueeText.width
    repeat: true

    // true = move right
    // false = move left
    property bool direction: true

    onTriggered: {
      marqueeText.tempX = marqueeText.tempX + (direction ? 5 : -5)
      scrollingText.x = -marqueeText.tempX;

      if (marqueeText.tempX + marqueeText.width > scrollingText.width ||
          marqueeText.tempX <= 0) {
        timer.running = false
        pauseTimer.running = true
      }
    }
  }

  Timer {
    id: pauseTimer
    interval: 500
    running: false
    repeat: false
    onTriggered: {
      timer.direction = !timer.direction
      timer.running = true
    }
  }
}
