pragma Singleton

import Quickshell

Singleton {
  function log(v: var, msg: string): void {
    console.log(`${msg ? msg + " " : ''}${v}`)
    return v
  }
}

