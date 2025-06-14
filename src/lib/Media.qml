pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import QtQuick

Singleton {
  id: root

  property int index: Mpris.players.values.length - 1
  property list<MprisPlayer> players: Mpris.players.values
  property MprisPlayer player: Mpris.players.values[index]
  property string url: player.trackArtUrl
  property color albumColor
  property double progress: player.position / player.length
  property double oldProgress
  property bool wheelReverse
  onProgressChanged: {
    if (progress < 0.001) {
      wheelReverse = true
    } else {
      wheelReverse = false
    }
    oldProgress = progress
  }

  function nextPlayer(dir = true) {
    if (dir && index == players.length - 1) {
      player = players[0]
    } else if (!dir && index == 0) {
      player = players[players.length - 1]
    } else {
      player = players[index + (dir ? 1 : -1)]
    }
    index = Mpris.players.indexOf(player)
  }

  function limit(str) {
    if (str.length >= 80) {
      return str.slice(0, 80) + '...'
    }
    return str
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
    function reloadAlbumColor(): void { artProcessor.running = true }
  }

  onPlayersChanged: player = players[players.length - 1]
  onUrlChanged: {
    coverUrlFile.setText(url)
    artProcessor.running = false
    artProcessor.running = true
  }

  Timer {
    running: player?.playbackState == MprisPlaybackState.Playing
    interval: 1000
    repeat: true
    onTriggered: {
      if (player.positionSupported) { player.positionChanged() }
    }
  }

  Process {
    id: artProcessor
    command: [ `${System.configPath}/scripts/album-art` ]
    stdout: SplitParser {
      onRead: data => {
        if (data.startsWith("#")) {
          root.albumColor = `${data}`
        }
      }
    }
    stderr: SplitParser {
      onRead: data => console.error(data)
    }
  }

  Process {
    running: true
    command: [ "touch", "/tmp/coverUrl" ]
  }

  FileView {
    id: coverUrlFile
    path: Qt.resolvedUrl("/tmp/coverUrl")
    blockWrites: true
  }
}

