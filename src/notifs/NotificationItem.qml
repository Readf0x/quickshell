import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import "../lib"
import "../subclass"

Rectangle {
  id: root
  
  required property var id
  required property Notification notification
  required property var model
  
  width: 240
  height: notifVertical.height
  color: Colors.background
  radius: 4
  
  function remove(reason) {
    if (reason == null) {
      notification.dismiss()
    }
    lock.locked = false
    for (let i = 0; i < model.count; i++) {
      if (model.get(i).id === id) {
        model.remove(i)
        break
      }
    }
  }

  readonly property list<string> activators: [
    "View",
    "Activate"
  ]
  function activateIncludes(str: string): bool {
    return activators.includes(str)
  }
  function activateFilter(actions: list<NotificationAction>): list<NotificationAction> {
    return actions.filter(a=>!activateIncludes(a))
  }
  function activateFind(actions: list<NotificationAction>): NotificationAction {
    actions.find(a=>activateIncludes(a))
  }

  Connections {
    target: notification
    function onClosed(reason) {
      remove(reason)
    }
  }

  onNotificationChanged: {
    if (root.notification == null) {
      remove(1)
    }
  }

  RetainableLock {
    id: lock
    object: root.notification
    locked: true
  }
  
  MouseArea {
    anchors.fill: parent
    id: fullArea
    onClicked: {
      if (notification.actions.length > 0 && notification.actions.some(a=>activateIncludes(a))) {
        notification.actions.find(a=>activateIncludes(a)).invoke()
      }
      let window = Hyprland.toplevels.values.find(t=>t.lastIpcObject.class == notification.appName || t.title == notification.appName)
      if (window) {
        Hyprland.dispatch(`workspace ${window.workspace.name}`)
        Hyprland.dispatch(`focuswindow address:0x${window.address}`)
      }
      root.remove()
    }
  }

  Column {
    id: notifVertical
    width: 230
    anchors.centerIn: parent
    topPadding: 3
    bottomPadding: 3

    Item {
      height: 16
      width: parent.width
      IconImage {
        implicitSize: 16
        visible: notification.appIcon != ""
        source: Quickshell.iconPath(notification.appIcon)
      }
      FText {
        anchors.centerIn: parent
        text: notification.summary
        font.pixelSize: 16
        width: Math.min(190, implicitWidth)
      }
      Item {
        anchors {
          right: parent.right
          verticalCenter: parent.verticalCenter
        }
        width: 24
        height: 24
        MouseArea {
          id: area
          hoverEnabled: true
          anchors.fill: parent
          property color propogatedColor: "transparent"
          acceptedButtons: Qt.LeftButton
          onClicked: root.remove()
        }
        Rectangle {
          anchors.centerIn: parent
          width: 12
          height: 2
          rotation: 45
          color: area.containsMouse ? area.pressed ? Colors.green : Colors.foreground : Colors.flight
        }
        Rectangle {
          anchors.centerIn: parent
          width: 12
          height: 2
          rotation: -45
          color: area.containsMouse ? area.pressed ? Colors.green : Colors.foreground : Colors.flight
        }
      }
    }

    RowLayout {
      width: parent.width
      spacing: 4
      visible: root.notification.body
      Image {
        source: notification.image
        visible: source != ""
        Layout.preferredHeight: 30
        Layout.preferredWidth: Math.min(60,
          (sourceSize.width / sourceSize.height) * Layout.preferredHeight)
      }
      FText {
        textFormat: Text.StyledText
        Layout.fillWidth: true

        text: notification.body
        font.pixelSize: 14
        wrapMode: Text.Wrap
        maximumLineCount: 3
      }
    }

    RowLayout {
      id: actions
      readonly property list<NotificationAction> filtered: activateFilter(notification.actions)
      visible: filtered.length > 0
      width: parent.width

      spacing: 4

      Repeater {
        model: filtered

        MouseArea {
          Layout.preferredHeight: 18
          Layout.fillWidth: true
          hoverEnabled: true
          onClicked: {
            modelData.invoke()
            root.remove()
          }
          Rectangle {
            anchors.fill: parent
            color: parent.containsMouse ? parent.pressed ? Colors.light : Colors.tlight : Colors.accent
            radius: 2
            FText {
              anchors.centerIn: parent
              text: modelData.text
            }
          }
        }
      }
    }
  }
}
