import QtQuick
import QtQuick.Controls
import ".." as App

Item {
    id: root
    signal signedIn()
    property string errorText: ""
    Rectangle { anchors.fill: parent; color: App.Theme.background }
    Column {
        width: parent.width - 44; anchors.centerIn: parent; spacing: 14
        Rectangle { anchors.horizontalCenter: parent.horizontalCenter; width: 82; height: 82; radius: 25; color: App.Theme.statusBackground("BLUE", true); border.color: App.Theme.blue; border.width: 2
            Text { anchors.centerIn: parent; text: "GM"; color: App.Theme.blue; font.pixelSize: 26; font.weight: Font.Bold }
            SequentialAnimation on scale { loops: Animation.Infinite; NumberAnimation { from: 1; to: 1.04; duration: 1100; easing.type: Easing.InOutSine } NumberAnimation { from: 1.04; to: 1; duration: 1100; easing.type: Easing.InOutSine } }
        }
        Text { anchors.horizontalCenter: parent.horizontalCenter; text: "Gate Monitor"; color: App.Theme.primaryText; font.pixelSize: 25; font.weight: Font.Bold }
        Text { anchors.horizontalCenter: parent.horizontalCenter; text: "Autentificare securizată"; color: App.Theme.secondaryText; font.pixelSize: 11 }
        Item { width: 1; height: 8 }
        TextField { id: email; width: parent.width; height: 48; text: "admin6@gatemonitor.ro"; placeholderText: "Email"; color: App.Theme.primaryText; leftPadding: 15; background: Rectangle { radius: 13; color: App.Theme.card; border.color: email.activeFocus ? App.Theme.blue : App.Theme.cardBorder } }
        TextField { id: password; width: parent.width; height: 48; text: "demo2026"; placeholderText: "Parolă"; echoMode: TextInput.Password; color: App.Theme.primaryText; leftPadding: 15; background: Rectangle { radius: 13; color: App.Theme.card; border.color: password.activeFocus ? App.Theme.blue : App.Theme.cardBorder } }
        Text { visible: root.errorText.length; text: root.errorText; color: App.Theme.red; font.pixelSize: 10 }
        Rectangle { width: parent.width; height: 50; radius: 14; color: loginMouse.pressed ? "#2567C7" : App.Theme.blue
            Text { anchors.centerIn: parent; text: "Conectare"; color: "white"; font.pixelSize: 13; font.weight: Font.Bold }
            MouseArea { id: loginMouse; anchors.fill: parent; onClicked: { if (App.AppState.signIn(email.text.trim(), password.text)) root.signedIn(); else root.errorText = "Completează emailul și parola." } }
        }
        Text { anchors.horizontalCenter: parent.horizontalCenter; text: "Demo: orice email și parolă completate"; color: App.Theme.secondaryText; font.pixelSize: 9 }
        Rectangle { width: parent.width; height: 58; radius: 13; color: App.Theme.card; border.color: App.Theme.cardBorder
            Text { anchors.centerIn: parent; width: parent.width - 24; text: "Sesiunea permite diferențierea dintre Admin și Utilizator."; color: App.Theme.secondaryText; font.pixelSize: 10; horizontalAlignment: Text.AlignHCenter; wrapMode: Text.WordWrap }
        }
    }
}
