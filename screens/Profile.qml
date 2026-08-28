import QtQuick
import QtQuick.Controls
import ".." as App

Item {
    id: root
    signal backRequested()
    Rectangle { anchors.fill: parent; color: App.Theme.background }
    Flickable { anchors.fill: parent; contentWidth: width; contentHeight: form.height + 40; clip: true
        Column { id: form; width: parent.width - 32; x: 16; y: 40; spacing: 12
            Row { width: parent.width; height: 44; spacing: 12
                Text { text: "‹"; color: App.Theme.primaryText; font.pixelSize: 28; MouseArea { anchors.fill: parent; anchors.margins: -10; onClicked: root.backRequested() } }
                Text { text: "Profil"; color: App.Theme.primaryText; font.pixelSize: 21; font.weight: Font.Bold }
            }
            Rectangle { width: parent.width; height: 106; radius: 14; color: App.Theme.card; border.color: App.Theme.cardBorder
                Rectangle { x: 16; anchors.verticalCenter: parent.verticalCenter; width: 62; height: 62; radius: 31; color: App.Theme.statusBackground("BLUE", false); Text { anchors.centerIn: parent; text: App.AppState.profileName.split(" ").map(function(v){return v[0]}).join(""); color: App.Theme.blue; font.pixelSize: 18; font.weight: Font.Bold } }
                Column { x: 94; anchors.verticalCenter: parent.verticalCenter; spacing: 5; Text { text: App.AppState.profileName; color: App.Theme.primaryText; font.pixelSize: 16; font.weight: Font.DemiBold } Text { text: App.AppState.profilePosition; color: App.Theme.secondaryText; font.pixelSize: 11 } Text { text: App.AppState.role; color: App.Theme.blue; font.pixelSize: 11; font.weight: Font.DemiBold } }
            }
            Field { label: "Nume"; value: App.AppState.profileName; onEdited: function(v) { App.AppState.profileName = v } }
            Field { label: "E-mail"; value: App.AppState.profileEmail; onEdited: function(v) { App.AppState.profileEmail = v } }
            Field { label: "Telefon"; value: App.AppState.profilePhone; onEdited: function(v) { App.AppState.profilePhone = v } }
            Field { label: "Funcție"; value: App.AppState.profilePosition; enabled: App.AppState.canEdit; onEdited: function(v) { App.AppState.profilePosition = v } }
            Rectangle { width: parent.width; height: 64; radius: 12; color: App.Theme.card; border.color: App.Theme.cardBorder
                Text { x: 14; y: 10; text: "Rol activ"; color: App.Theme.secondaryText; font.pixelSize: 10 }
                Text { x: 14; y: 31; text: App.AppState.role; color: App.Theme.primaryText; font.pixelSize: 13; font.weight: Font.Medium }
                Text { anchors.right: parent.right; anchors.rightMargin: 14; anchors.verticalCenter: parent.verticalCenter; text: "Gestionat de sistem"; color: App.Theme.secondaryText; font.pixelSize: 10 }
            }
            Text { text: "Modificările sunt salvate în sesiunea curentă."; color: App.Theme.secondaryText; font.pixelSize: 10; anchors.horizontalCenter: parent.horizontalCenter }
        }
    }
    component Field: Rectangle {
        id: fieldRoot; required property string label; required property string value; signal edited(string value)
        width: form.width; height: 70; radius: 12; color: App.Theme.card; border.color: input.activeFocus ? App.Theme.blue : App.Theme.cardBorder
        Text { x: 14; y: 8; text: fieldRoot.label; color: App.Theme.secondaryText; font.pixelSize: 10 }
        TextInput { id: input; x: 14; y: 29; width: parent.width - 28; text: fieldRoot.value; color: fieldRoot.enabled ? App.Theme.primaryText : App.Theme.secondaryText; font.pixelSize: 13; selectByMouse: true; readOnly: !fieldRoot.enabled; onEditingFinished: fieldRoot.edited(text) }
    }
}
