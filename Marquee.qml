import QtQuick

Item {
  id: marqueeText
  height: scrollingText.height
  clip: true

  property int tempX: 0
  property alias text: scrollingText.text
  property alias color: scrollingText.color

  property alias speed: scroller.interval
  property alias pauseTime: pauseTimer.interval

  onTextChanged: {
    scroller.running = false
    scrollingText.x = 0
    tempX = 0
    if (scrollingText.width > marqueeText.width) {
      scroller.direction = false
      pauseTimer.running = true
    }
  }

  Text {
    x: tempX
    id: scrollingText

    color: Colors.foreground

    font.family: "Courier"
    font.pointSize: 11
  }

  Timer {
    id: scroller
    interval: 200
    running: false
    repeat: true

    // true = move right
    // false = move left
    property bool direction: false

    onTriggered: {
      if (scrollingText.width < marqueeText.width) {
        scrollingText.x = 0
        tempX = 0
        scroller.running = false
      } else {
        tempX = tempX + (direction ? 5 : -5)
        scrollingText.x = -tempX;

        if (tempX + marqueeText.width > scrollingText.width ||
            tempX <= 0) {
          scroller.running = false
          pauseTimer.running = true
        }
      }
    }
  }

  Timer {
    id: pauseTimer
    interval: 750
    running: scrollingText.width > marqueeText.width
    repeat: false
    onTriggered: {
      scroller.direction = !scroller.direction
      scroller.running = true
    }
  }
}
