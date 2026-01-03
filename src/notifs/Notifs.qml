import Quickshell
import Quickshell.Services.Notifications
import QtQuick

PanelWindow {
  id: root

  anchors {
    right: true
    top: true
    bottom: true
  }

  width: 248

  color: "transparent"

  implicitWidth: 248
  exclusiveZone: 0

  mask: Region {
    width: 248
    height: list.contentHeight + 8
  }

  ListModel {
    id: notificationsModel

    onCountChanged: {
      for (let i = count - 1; i >= 0; i--) {
        if (!get(i).notification) {
          remove(i)
        }
      }
    }

    function findNotificationIndex(notificationId) {
      for (let i = 0; i < count; i++) {
        if (get(i).id === notificationId) {
          return i
        }
      }
      return -1
    }
  }

  NotificationServer {
    id: server

    actionsSupported: true
    bodyMarkupSupported: true
    imageSupported: true
    persistenceSupported: true

    onNotification: notif => {
      notif.tracked = true
      
      // Check if a notification with this ID already exists (indicates replacement)
      const existingIndex = notificationsModel.findNotificationIndex(notif.id)
      if (existingIndex !== -1) {
        // Replace existing notification
        notificationsModel.set(existingIndex, {
          "id": notif.id,
          "notification": notif
        })
      } else {
        // Add as new notification
        notificationsModel.append({
          "id": notif.id,
          "notification": notif
        })
      }
    }
  }
  Item {
    id: listContainer
    anchors.fill: parent
    
    ListView {
      id: list
      spacing: 4

      height: parent.height

      anchors {
        top: parent.top
        right: parent.right
        left: parent.left
        margins: 4
      }

      model: notificationsModel

      delegate: NotificationItem {
        model: notificationsModel
      }

      add: Transition {
        NumberAnimation { property: "x"; from: list.width; duration: 200; easing.type: Easing.OutQuad }
      }

      addDisplaced: Transition {
        NumberAnimation { property: "y"; duration: 200; easing.type: Easing.OutQuad }
      }

      remove: Transition {
        NumberAnimation { property: "x"; to: list.width; duration: 200; easing.type: Easing.InQuad }
        NumberAnimation { property: "opacity"; to: 0; duration: 200 }
      }

      removeDisplaced: Transition {
        NumberAnimation { property: "y"; duration: 200; easing.type: Easing.OutQuad }
      }

      move: Transition {
        NumberAnimation { property: "y"; duration: 150; easing.type: Easing.OutQuad }
      }

      moveDisplaced: Transition {
        NumberAnimation { property: "y"; duration: 150; easing.type: Easing.OutQuad }
      }
    }
  }
}

