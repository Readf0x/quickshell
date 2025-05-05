pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root

  property list<int> cava: [0,0,0,0,0,0,0,0,0,0]

  Process {
    running: true
    command: ["cava", "-p", "/home/readf0x/.config/cava/shell.conf"]
    stdout: SplitParser {
      onRead: data => {
        root.cava = data.split(";").filter(s=>s!='').map(i=>Number(i))
      }
    }
  }
}

