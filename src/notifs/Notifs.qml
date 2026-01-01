import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import "../lib"
import "../subclass"

PanelWindow {
  id: root

  anchors {
    right: true
    top: true
    bottom: true
  }

  color: "transparent"

  implicitWidth: 248
  exclusiveZone: 0

  mask: Region {
    item: list
  }

  property list<Notification> notifications

  onNotificationsChanged: {
    if (notifications.some(n=>n==null)) {
      notifications = notifications.filter(n=>n!=null)
    }
  }

  NotificationServer {
    id: server

    actionsSupported: true
    bodyHyperlinksSupported: true
    bodyMarkupSupported: true
    imageSupported: true
    persistenceSupported: true

    onNotification: notif => {
      notif.tracked = true
      root.notifications = [notif, ...root.notifications]
    }
  }

  Column {
    id: list
    spacing: 4

    anchors {
      top: parent.top
      right: parent.right
      left: parent.left
      margins: 4
    }

    Repeater {
      id: repeater
      model: root.notifications

      Rectangle {
        required property Notification modelData
        width: 240
        height: notifVertical.height
        color: Colors.background
        radius: 4
        MouseArea {
          anchors.fill: parent
          id: fullArea
          onClicked: {
            let thisNotif = modelData
            Hyprland.dispatch(`focuswindow class:${thisNotif.appName}`)
            root.notifications = root.notifications.filter(n=>n.id!=thisNotif.id)
            thisNotif.dismiss()
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
              visible: modelData.appIcon != ""
              source: Quickshell.iconPath(modelData.appIcon)
            }
            FText {
              anchors.centerIn: parent
              text: modelData.summary
              font.pixelSize: 16
              width: Math.min(190, implicitWidth)
            }
            IconImage {
              anchors {
                right: parent.right
              }
              source: Quickshell.iconPath("dialog-close")
              implicitSize: 16
              MouseArea {
                id: area
                hoverEnabled: true
                anchors.fill: parent
                property color propogatedColor: "transparent"
                acceptedButtons: Qt.LeftButton
                onClicked: {
                  let thisNotif = modelData
                  root.notifications = root.notifications.filter(n=>n.id!=thisNotif.id)
                  thisNotif.dismiss()
                }
              }
              Rectangle {
                color: area.containsMouse ? area.pressed ? Colors.gray : Colors.tgray : "transparent"
                anchors.fill: parent
              }
            }
          }

          RowLayout {
            width: parent.width
            spacing: 4
            Image {
              source: modelData.image
              visible: source != ""
              Layout.preferredHeight: 30
              Layout.preferredWidth: Math.min(60,
                (sourceSize.width / sourceSize.height) * Layout.preferredHeight)
            }
            FText {
              textFormat: Text.StyledText
              Layout.fillWidth: true

              text: modelData.body
              font.pixelSize: 14
              wrapMode: Text.Wrap
              maximumLineCount: 3
            }
          }

          RowLayout {
            id: actions
            visible: modelData.actions.length > 0
            width: parent.width
            property var thisNotif: modelData

            spacing: 4

            Repeater {
              model: modelData.actions

              MouseArea {
                Layout.preferredHeight: 18
                Layout.fillWidth: true
                hoverEnabled: true
                onClicked: {
                  modelData.invoke()
                  root.notifications = root.notifications.filter(n=>n.id!=actions.thisNotif.id)
                  actions.thisNotif.dismiss()
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
    }
  }
}

