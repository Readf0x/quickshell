pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root

  property list<int> bars: Array.apply(null, Array(42)).map(()=>{return 0})
  function scale(targetSize) {
    const len = bars.length;
    if (len === targetSize) return bars;
    
    const result = new Array(targetSize);
    const ratio = len / targetSize;
    
    if (len > targetSize) {
      // Downsampling: fast averaging
      for (let i = 0; i < targetSize; i++) {
        const start = (i * ratio) | 0;
        const end = ((i + 1) * ratio) | 0;
        
        let sum = 0;
        for (let j = start; j < end; j++) {
          sum += bars[j];
        }
        result[i] = sum / (end - start);
      }
    } else {
      // Upsampling: fast linear interpolation
      const r = (len - 1) / (targetSize - 1);
      
      for (let i = 0; i < targetSize; i++) {
        const pos = i * r;
        const idx = pos | 0;
        const frac = pos - idx;
        
        result[i] = idx === len - 1 
          ? bars[idx]
          : bars[idx] + (bars[idx + 1] - bars[idx]) * frac;
      }
    }
    
    return result;
  }

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

