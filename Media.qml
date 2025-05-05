pragma Singleton

import Quickshell
import Quickshell.Services.Mpris

Singleton {
  id: root

  property MprisPlayer player: Mpris.players.values[0]

  function nextPlayer(dir = true) {
    player = Mpris.players.values[Mpris.players.indexOf(player) + (dir ? 1 : -1)]
  }
}

