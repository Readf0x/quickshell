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
  }

  NotificationServer {
    id: server

    actionsSupported: true
    bodyMarkupSupported: true
    imageSupported: true
    persistenceSupported: true

    onNotification: notif => {
      notif.tracked = true
      notificationsModel.append({
        "id": notif.id,
        "notification": notif
      })
    }
  }
  Item {
    id: listContainer
    
    anchors {
      fill: parent
    }
    
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
    }
  }
}

