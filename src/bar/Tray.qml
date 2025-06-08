import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick
import "../widgets"

WrapWidget {
  Row {
    Repeater {
      model: SystemTray.items
      Item {
        id: root
        width: 26; height: 26
        required property var modelData
        IconImage {
          anchors.centerIn: parent
          // [TODO] filter icons and replace with ones that match the theme
          source: {
            let icon = modelData.icon
            if (icon.includes("?path=")) {
              const [name, path] = icon.split("?path=")
              icon = `file://${path}/${name.slice(name.lastIndexOf("/") + 1)}`
            }
            return icon
          }
          implicitSize: 18
        }
        MouseArea {
          anchors.fill: parent
          acceptedButtons: Qt.LeftButton | Qt.RightButton
          onClicked: event => {
            switch (event.button) {
              case Qt.LeftButton: modelData.activate(); break;
              case Qt.RightButton: 
                if (modelData.hasMenu) {
                  const window = QsWindow.window;
                  // the bellow is kinda hard coded, find a better solution
                  const widgetRect = window.contentItem.mapFromItem(root, 10, root.height - 10, root.width, root.height);
                  menuAnchor.anchor.rect = widgetRect;
                  menuAnchor.open();
                }
                break;
            }
          }
        }
        QsMenuAnchor {
          id: menuAnchor
          menu: modelData.menu
          anchor.window: root.QsWindow.window?? null
          anchor.adjustment: PopupAdjustment.Flip
        }
      }
    }
  }
}

