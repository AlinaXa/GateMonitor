import QtQuick
import ".." as App
import "../components"

Item {
    id: root
    signal openLocations()
    signal openGate()
    signal openProfile()
    signal openHistory()
    signal navigationRequested(string destination)
    Rectangle { anchors.fill: parent; color: App.Theme.background }
    Column { anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top; anchors.bottom: nav.top; anchors.margins: 16; anchors.topMargin: 42; spacing: 12
        Text { text: "Meniu"; color: App.Theme.primaryText; font.pixelSize: 22; font.weight: Font.Bold }
        Rectangle { width: parent.width; height: 82; radius: 14; color: App.Theme.card; border.color: App.Theme.cardBorder
            Rectangle { x: 14; anchors.verticalCenter: parent.verticalCenter; width: 46; height: 46; radius: 23; color: App.Theme.statusBackground("BLUE", false); Text { anchors.centerIn: parent; text: "A6"; color: App.Theme.blue; font.pixelSize: 14; font.weight: Font.Bold } }
            Column { x: 72; anchors.verticalCenter: parent.verticalCenter; spacing: 3; Text { text: App.AppState.profileName; color: App.Theme.primaryText; font.pixelSize: 14; font.weight: Font.DemiBold } Text { text: App.AppState.profilePosition; color: App.Theme.secondaryText; font.pixelSize: 11 } Text { text: App.AppState.role; color: App.Theme.blue; font.pixelSize: 10 } }
            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: root.openProfile() }
        }
        Repeater { model: [{label:"Profilul meu",detail:"Date personale și preferințe",action:"profile"},{label:"Istoric și audit",detail:"Toate logurile și modificările",action:"history"},{label:"Schimbă locația",detail:"Selectează alt depou",action:"locations"},{label:"Poarta curentă",detail:"Deschide P014",action:"gate"}]
            delegate: Rectangle { required property var modelData; width: root.width - 32; height: 68; radius: 12; color: mouse.containsMouse ? App.Theme.cardHover : App.Theme.card; border.color: App.Theme.cardBorder
                Column { x: 16; anchors.verticalCenter: parent.verticalCenter; width: parent.width - 58; spacing: 4; Text { text: modelData.label; color: App.Theme.primaryText; font.pixelSize: 13; font.weight: Font.Medium } Text { text: modelData.detail; color: App.Theme.secondaryText; font.pixelSize: 10 } }
                Text { anchors.right: parent.right; anchors.rightMargin: 16; anchors.verticalCenter: parent.verticalCenter; text: "›"; color: App.Theme.blue; font.pixelSize: 23 }
                MouseArea { id: mouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: { if (modelData.action === "locations") root.openLocations(); else if (modelData.action === "gate") root.openGate(); else if (modelData.action === "profile") root.openProfile(); else if (modelData.action === "history") root.openHistory() } }
            }
        }
        Rectangle { width: parent.width; height: 52; radius: 12; color: App.Theme.statusBackground(App.AppState.role === "Admin" ? "BLUE" : "GREEN", false); border.color: App.Theme.statusColor(App.AppState.role === "Admin" ? "BLUE" : "GREEN")
            Text { x: 14; anchors.verticalCenter: parent.verticalCenter; text: "Previzualizare rol: " + App.AppState.role; color: App.Theme.primaryText; font.pixelSize: 11; font.weight: Font.Medium }
            Text { anchors.right: parent.right; anchors.rightMargin: 14; anchors.verticalCenter: parent.verticalCenter; text: "Schimbă"; color: App.Theme.blue; font.pixelSize: 11 }
            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: App.AppState.role = App.AppState.role === "Admin" ? "Utilizator" : "Admin" }
        }
        Text { text: "Gate Monitor · versiunea 1.0"; color: App.Theme.secondaryText; font.pixelSize: 10; anchors.horizontalCenter: parent.horizontalCenter }
    }
    BottomNavigation { id: nav; anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; currentItem: "menu"; onNavigationRequested: function(d) { root.navigationRequested(d) } }
}
