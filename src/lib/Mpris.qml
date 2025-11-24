pragma Singleton

import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Mpris
import QtQuick

Singleton {
  id: root

  property int index
	property string playerID
  property MprisPlayer player
  property list<MprisPlayer> players: Mpris.players.values
	property list<MprisPlaybackState> playerStates: players.map(p=>p.playbackState)
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
		playerID = player.identity
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

	function updatePlayer() {
		let newIndex = players.find(p=>p.identity == playerID)
		let currentlyPlaying = players.filter(p=>p.playbackState == MprisPlaybackState.Playing)
		if (newIndex && newIndex.playbackState != MprisPlaybackState.Playing && currentlyPlaying.length) {
			player = currentlyPlaying[currentlyPlaying.length - 1]
			playerID = player.identity
		} else if (!newIndex) {
			if (currentlyPlaying.length) {
				player = currentlyPlaying[currentlyPlaying.length - 1]
			} else {
				player = players[players.length - 1]
			}
		} else {
			player = newIndex
		}
		index = players.indexOf(player)
	}

	onPlayersChanged: updatePlayer()
	onPlayerStatesChanged: updatePlayer()

  Timer {
    running: player?.playbackState == MprisPlaybackState.Playing
    interval: 1000
    repeat: true
    onTriggered: {
      if (player.positionSupported) { player.positionChanged() }
    }
  }
}

