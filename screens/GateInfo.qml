import QtQuick
import ".." as App
import "../components"

Item {
    id: root
    property string gateId: "P014"
    property string gateName: "Intrare Principală"
    property string locationName: "Depou Berceni"
    signal backRequested()
    signal historyRequested()
    signal motorRequested(string motorId)
    Rectangle { anchors.fill: parent; color: App.Theme.background }
    Column { anchors.fill: parent; anchors.margins: 16; anchors.topMargin: 42; spacing: 14
        Row { width: parent.width; height: 42; spacing: 12; Text { text: "‹"; color: App.Theme.primaryText; font.pixelSize: 28; MouseArea { anchors.fill: parent; anchors.margins: -10; onClicked: root.backRequested() } } Text { text: "Informații poartă"; color: App.Theme.primaryText; font.pixelSize: 21; font.weight: Font.Bold } }
        Rectangle { width: parent.width; height: 132; radius: 16; color: App.Theme.statusBackground("BLUE", false); border.color: App.Theme.blue; border.width: 2
            Column { anchors.centerIn: parent; spacing: 5; Text { anchors.horizontalCenter: parent.horizontalCenter; text: root.gateId; color: App.Theme.primaryText; font.pixelSize: 25; font.weight: Font.Bold } Text { anchors.horizontalCenter: parent.horizontalCenter; text: root.gateName; color: App.Theme.blue; font.pixelSize: 13 } Text { anchors.horizontalCenter: parent.horizontalCenter; text: root.locationName; color: App.Theme.secondaryText; font.pixelSize: 11 } }
        }
        Repeater { model: [{a:"Status",b:"Activă",s:"BLUE",action:"history"},{a:"Motoare",b:"6 conectate",s:"GREEN",action:"motor"},{a:"Poziție",b:"Deschisă",s:"BLUE",action:"history"},{a:"Ultima comandă",b:"01:37 · Admin 6",s:"BLUE",action:"history"},{a:"Cicluri totale",b:"48.921",s:"GREEN",action:"history"},{a:"Mentenanță",b:"12 Sep 2026",s:"YELLOW",action:"history"}]
            delegate: Rectangle { required property var modelData; width: parent.width; height: 62; radius: 12; color: mouse.containsMouse ? App.Theme.cardHover : App.Theme.card; border.color: App.Theme.cardBorder; StatusDot { x: 14; anchors.verticalCenter: parent.verticalCenter; status: modelData.s } Text { x: 36; anchors.verticalCenter: parent.verticalCenter; text: modelData.a; color: App.Theme.secondaryText; font.pixelSize: 11 } Text { anchors.right: arrow.left; anchors.rightMargin: 8; anchors.verticalCenter: parent.verticalCenter; text: modelData.b; color: App.Theme.primaryText; font.pixelSize: 12; font.weight: Font.Medium } Text { id: arrow; anchors.right: parent.right; anchors.rightMargin: 12; anchors.verticalCenter: parent.verticalCenter; text: "›"; color: App.Theme.blue; font.pixelSize: 20 } MouseArea { id: mouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: { if (modelData.action === "motor") root.motorRequested("M1"); else root.historyRequested() } } }
        }
    }
}
