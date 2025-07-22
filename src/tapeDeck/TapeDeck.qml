import Quickshell
import Quickshell.Io
import QtQuick
import "../widgets"

PopupWindow {
  id: popup
  anchor.window: root
  anchor.rect.x: parentWindow.width / 2 - width / 2
  // align underneath
  // anchor.rect.y: parentWindow.height + 2
  // align on top
  anchor.rect.y: parentWindow.height + 2
  implicitWidth: 216; implicitHeight: 160
  Widget {
    anchors.fill: parent

    MegaCassette {
      id: dlls
      x: 2; y: 2
    }

    Row {
      anchors.top: dlls.bottom
      x: 2
      spacing: 2
      DeckButton {
        width: 80
        position: 1
        type: "play"
      }
      DeckButton {
        type: "pause"
      }
      DeckButton {
        type: "stop"
      }
      DeckButton {
        type: "back"
      }
      DeckButton {
        position: 2
        type: "next"
      }
    }
  }

  IpcHandler {
    target: "popup"

    function toggleVisible(): void { popup.visible = !popup.visible }
  }
}

