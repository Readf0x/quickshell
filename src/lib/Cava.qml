pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root

  property list<int> bars: Array.apply(null, Array(42)).map(()=>{return 0})

  Process {
    running: true
    command: ["cava", "-p", `${Quickshell.env("QS_CONFIG_PATH")}/lib/cava.conf`]
    stdout: SplitParser {
      onRead: data => {
        root.bars = data.split(";").filter(s=>s!='').map(i=>Number(i))
      }
    }
  }
}

