import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pipewire
import QtQuick
import "../lib"

PanelWindow {
  id: volumeWindow

  WlrLayershell.layer: WlrLayer.Overlay

  anchors {
    bottom: true
  }
  exclusionMode: ExclusionMode.Ignore
  mask: Region {}

  margins {
    bottom: 30
  }

  color: "transparent"

  width: 400
  height: 16
  
  visible: true
  
  property var defaultSink: Pipewire.defaultAudioSink
  property real currentVolume: 0
  property bool isMuted: false
  property bool shouldBeVisible: false
  
  Timer {
    id: hideTimer
    interval: 2000
    onTriggered: shouldBeVisible = false
  }
  
  function showVolumeIndicator() {
    shouldBeVisible = true
    hideTimer.restart()
  }
  
  function updateVolume() {
    if (defaultSink && defaultSink.audio) {
      currentVolume = defaultSink.audio.volumes[0] || 0
      isMuted = defaultSink.audio.muted || false
      showVolumeIndicator()
    }
  }
  
  onDefaultSinkChanged: {
    updateVolume()
  }

  Rectangle {
    anchors.fill: parent
    color: Colors.background
    radius: 8
    
    opacity: shouldBeVisible ? 1 : 0
    
    Behavior on opacity {
      NumberAnimation {
        duration: 200
        easing.type: Easing.InOutQuad
      }
    }
    
    Rectangle {
      anchors.fill: parent
      anchors.margins: 4
      color: Colors.tgray
      radius: 4
      
      Rectangle {
        width: parent.width * (isMuted ? 0 : currentVolume)
        height: parent.height
        color: isMuted ? Colors.tgray : Colors.green
        radius: 4
        
        Behavior on width {
          NumberAnimation {
            duration: 150
            easing.type: Easing.InOutQuad
          }
        }
        
        Behavior on color {
          ColorAnimation {
            duration: 150
          }
        }
      }
    }
  }
  
  PwObjectTracker {
    objects: [defaultSink]
  }
  
  Component.onCompleted: {
    // Update volume if sink is already available
    if (defaultSink) {
      updateVolume()
    }
  }
  
  Connections {
    target: defaultSink ? defaultSink.audio : null
    function onVolumesChanged() {
      updateVolume()
    }
    function onMutedChanged() {
      updateVolume()
    }
  }
}
