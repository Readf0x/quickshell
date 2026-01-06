import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../subclass"

MouseArea {
  required property DesktopEntry desktop
  height: 24
  width: parent.width

  cursorShape: Qt.PointingHandCursor
  onClicked: {
    console.log(desktop.name)
    desktop.execute()
  }

  RowLayout {
    IconImage {
      source: Quickshell.iconPath(desktop.icon)
      Layout.preferredHeight: 24
      Layout.preferredWidth: Layout.preferredHeight
      Layout.alignment: Qt.AlignRight
    }

    FText {
      text: desktop.name
      Layout.fillWidth: true
      Layout.fillHeight: true
      verticalAlignment: Text.AlignVCenter
    }
  }
}
