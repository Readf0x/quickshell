import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "../lib"
import "../subclass"

FloatingWindow {
  id: root
  title: "Launcher"

  color: Colors.background

  implicitWidth: 400
  implicitHeight: 300

  visible: false

  GlobalShortcut {
    name: "launcher"
    onPressed: root.visible = !root.visible
  }

  ListView {
    id: listView

    keyNavigationEnabled: true
    keyNavigationWraps: true
    currentIndex: 0

    highlight: Rectangle {
      color: Colors.accent
      opacity: 0.5
    }

    onCountChanged: {
      if (count > 0) {
        currentIndex = 0;
      }
    }

    anchors {
      topMargin: 26
      fill: parent
    }
    model: ScriptModel {
      id: filteredApplications

      values: {
        const allApps = DesktopEntries.applications.values;
        if (!search.text || search.text.length === 0) {
          return allApps;
        }
        
        const query = search.text.toLowerCase();
        return allApps
          .map(app => {
            const nameMatch = app.name.toLowerCase().includes(query);
            const genericNameMatch = app.genericName && app.genericName.toLowerCase().includes(query);
            const commentMatch = app.comment && app.comment.toLowerCase().includes(query);
            const keywordsMatch = app.keywords.some(keyword => keyword.toLowerCase().includes(query));
            const categoriesMatch = app.categories.some(category => category.toLowerCase().includes(query));
            
            const matches = nameMatch || genericNameMatch || commentMatch || keywordsMatch || categoriesMatch;
            
            return {
              app: app,
              score: matches ? (nameMatch ? 100 : 50) + (query === app.name.toLowerCase() ? 200 : 0) : 0
            };
          })
          .filter(item => item.score > 0)
          .sort((a, b) => b.score - a.score)
          .map(item => item.app);
      }
    }
    
    delegate: ListItem {
      required property DesktopEntry modelData
      desktop: modelData
      width: listView.width
    }
  }

  Rectangle {
    width: parent.width
    height: 24
    color: Colors.background

    RowLayout {
      anchors.fill: parent
      anchors.leftMargin: 3
      anchors.rightMargin: 3
      FText {
        Layout.fillHeight: true
        Layout.alignment: Qt.AlignLeft
        verticalAlignment: Text.AlignVCenter

        color: Colors.yellow

        text: "∫"
      }
      TextInput {
        id: search
        Layout.fillWidth: true
        Layout.fillHeight: true
        verticalAlignment: Text.AlignVCenter

        color: Colors.foreground
        selectionColor: Colors.foreground
        selectedTextColor: Colors.background
        focus: true

        font {
          family: "Varela Round"
        }

        Keys.onDownPressed: listView.currentIndex++
        Keys.onUpPressed: listView.currentIndex--
        onAccepted: {
          listView.currentItem.desktop.execute()
          root.visible = false
          text = ""
        }
        Keys.onEscapePressed: {
          root.visible = false
          text = ""
        }
      }
    }
  }
}

