pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import QtQuick

Singleton {
  id: root

  property list<MprisPlayer> players: Mpris.players.values
  property MprisPlayer player: Mpris.players.values[index]
  property int index: 0

  function nextPlayer(dir = true) {
    if (dir && index == players.length - 1) {
      player = players[0]
    } else if (!dir && index == 0) {
      player = players[players.length - 1]
    } else {
      player = players[players.indexOf(player) + (dir ? 1 : -1)]
    }
    index = Mpris.players.indexOf(player)
  }

  IpcHandler {
    target: "player"

    function playPause(): void {
      player.isPlaying ? player.pause() : player.play()
    }
    function play(): void { player.play() }
    function pause(): void { player.pause() }
    function stop(): void { player.stop() }
    function next(): void { player.next() }
    function previous(): void { player.previous() }
    function nextPlayer(): void { root.nextPlayer() }
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

