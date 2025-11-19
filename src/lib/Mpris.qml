pragma Singleton

import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Mpris
import QtQuick

Singleton {
  id: root

  property int index: Mpris.players.values.length - 1
  property list<MprisPlayer> players: Mpris.players.values
  property MprisPlayer player: Mpris.players.values[index]
  property double progress: player.position / player.length

	property var formatted: {
		let matches = player.trackTitle.match(/(.*) [-—] (.*)/)
		if (
			matches &&
			matches.length &&
			!player.trackAlbumArtist &&
			!player.trackArtist
		) {
			return {
				title: matches[1],
				subtitle: matches[2]
			}
		}
		return {
			title: player.trackTitle,
			subtitle: player.trackArtist || player.trackAlbumArtist || "Unknown Artist"
		}
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

	GlobalShortcut {
		name: "playPause"
		onPressed: {
			player.isPlaying ? player.pause() : player.play()
		}
	}
	GlobalShortcut {
		name: "play"
		onPressed: {
			player.play()
		}
	}
	GlobalShortcut {
		name: "pause"
		onPressed: {
			player.pause()
		}
	}
	GlobalShortcut {
		name: "stop"
		onPressed: {
			player.stop()
		}
	}
	GlobalShortcut {
		name: "next"
		onPressed: {
			player.next()
		}
	}
	GlobalShortcut {
		name: "previous"
		onPressed: {
			player.previous()
		}
	}
	GlobalShortcut {
		name: "nextPlayer"
		onPressed: {
			root.nextPlayer()
		}
	}

  onPlayersChanged: player = players[players.length - 1]

  Timer {
    running: player?.playbackState == MprisPlaybackState.Playing
    interval: 1000
    repeat: true
    onTriggered: {
      if (player.positionSupported) { player.positionChanged() }
    }
  }
}

