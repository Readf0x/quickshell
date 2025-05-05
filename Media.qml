pragma Singleton

import Quickshell
import Quickshell.Services.Mpris
import QtQuick

Singleton {
  id: root

  property list<MprisPlayer> players: Mpris.players.values
  property MprisPlayer player: Mpris.players.values[index]
  property int index: 0

  function nextPlayer(dir = true) {
    player = Mpris.players.values[Mpris.players.indexOf(player) + (dir ? 1 : -1)]
    index = Mpris.players.indexOf(player)
  }

  onPlayersChanged: {
    if (Mpris.players.values.length != 0) {
      if (! Mpris.players.values.includes(player)) {
        player = Mpris.players.values[index > Mpris.players.values.length - 1 ? Mpris.players.values.length - 1 : index]
      }
    } else {
      player = null
    }
  }

  Timer {
    running: player.playbackState == MprisPlaybackState.Playing
    interval: 1000
    repeat: true
    onTriggered: player.positionChanged()
  }
}

