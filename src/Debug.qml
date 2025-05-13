pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
  function log(v: var, msg: string): void {
    console.log(`${msg != "undefined" ? msg + " " : ''}${v}`)
    return v
  }
  function loadDebugBecauseQuickshellHasSuperLazySingletonEvaluationAndTheIpcHandlerDoesntAppearOtherwise(val) { return val }

  IpcHandler {
    target: "debug"

    function run(func: string): string {
      return eval(func)
    }
  }
}

