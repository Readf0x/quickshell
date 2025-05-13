pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root

  property list<int> cava: [0,0,0,0,0,0,0,0,0,0]
  property list<var> colors: [
    [[Colors.background, Colors.background],[Colors.background, Colors.background],[Colors.background, Colors.background],[Colors.background, Colors.background]],
    [[Colors.background, Colors.background],[Colors.background, Colors.background],[Colors.background, Colors.background],[Colors.background, Colors.background]],
    [[Colors.background, Colors.background],[Colors.background, Colors.background],[Colors.background, Colors.background],[Colors.background, Colors.background]],
    [[Colors.background, Colors.background],[Colors.background, Colors.background],[Colors.background, Colors.background],[Colors.background, Colors.background]],
    [[Colors.background, Colors.background],[Colors.background, Colors.background],[Colors.background, Colors.background],[Colors.background, Colors.background]],
    [[Colors.background, Colors.background],[Colors.background, Colors.background],[Colors.background, Colors.background],[Colors.background, Colors.background]],
    [[Colors.background, Colors.background],[Colors.background, Colors.background],[Colors.background, Colors.background],[Colors.background, Colors.background]],
    [[Colors.background, Colors.background],[Colors.background, Colors.background],[Colors.background, Colors.background],[Colors.background, Colors.background]],
    [[Colors.background, Colors.background],[Colors.background, Colors.background],[Colors.background, Colors.background],[Colors.background, Colors.background]],
    [[Colors.background, Colors.background],[Colors.background, Colors.background],[Colors.background, Colors.background],[Colors.background, Colors.background]],
  ]

  function processColors(color, num) {
    const gradient = [
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.red
    ]

    switch (num) {
      case 0:
        return [Colors.background, Colors.background];
      case 1:
        return [Colors.background, gradient[color]];
      case 2:
        return [gradient[color], gradient[color]];
    }
  }

  function processHeight(num) {
    return [
      processColors(0, Math.min(Math.max(num - 6, 0), 2)),
      processColors(1, Math.min(Math.max(num - 4, 0), 2)),
      processColors(2, Math.min(Math.max(num - 2, 0), 2)),
      processColors(3, Math.min(Math.max(num, 0), 2)),
    ]
  }

  Process {
    running: true
    command: ["cava", "-p", "./cava.conf"]
    stdout: SplitParser {
      onRead: data => {
        root.cava = data.split(";").filter(s=>s!='').map(i=>Number(i))
        root.colors = root.cava.map(root.processHeight)
      }
    }
  }
}

