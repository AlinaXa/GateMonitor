import QtQuick
import ".." as App
import "../components"

Item {
    id: root
    signal openMotor(string motorId)
    signal navigationRequested(string destination)
    Rectangle { anchors.fill: parent; color: App.Theme.background }
    Column { anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top; anchors.bottom: nav.top; anchors.margins: 16; anchors.topMargin: 42; spacing: 12
        Text { text: "Alarme"; color: App.Theme.primaryText; font.pixelSize: 22; font.weight: Font.Bold }
        Text { text: "2 alarme active"; color: App.Theme.secondaryText; font.pixelSize: 12 }
        Repeater { model: [
            { motor:"M3", gate:"P014 · Intrare Principală", title:"Supraîncălzire", detail:"Temperatură peste limita admisă", time:"01:25", state:"RED" },
            { motor:"M2", gate:"P014 · Intrare Principală", title:"Vibrații peste limită", detail:"Este recomandată o inspecție", time:"01:36", state:"YELLOW" }
        ]
            delegate: Rectangle { required property var modelData; width: root.width - 32; height: 112; radius: 14; color: mouse.containsMouse ? App.Theme.cardHover : App.Theme.card; border.color: App.Theme.statusColor(modelData.state); border.width: 1
                StatusDot { x: 16; y: 18; status: modelData.state }
                Column { x: 36; y: 14; width: parent.width - 92; spacing: 4; Text { text: modelData.motor + " · " + modelData.title; color: App.Theme.primaryText; font.pixelSize: 13; font.weight: Font.DemiBold } Text { width: parent.width; text: modelData.detail; color: App.Theme.secondaryText; font.pixelSize: 11; wrapMode: Text.WordWrap } Text { text: modelData.gate; color: App.Theme.secondaryText; font.pixelSize: 10 } }
                Text { anchors.right: parent.right; anchors.rightMargin: 14; y: 15; text: modelData.time; color: App.Theme.secondaryText; font.pixelSize: 10 }
                Text { anchors.right: parent.right; anchors.rightMargin: 14; anchors.bottom: parent.bottom; anchors.bottomMargin: 14; text: "Detalii ›"; color: App.Theme.blue; font.pixelSize: 11 }
                MouseArea { id: mouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: root.openMotor(modelData.motor) }
            }
        }
    }
    BottomNavigation { id: nav; anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; currentItem: "alarms"; onNavigationRequested: function(d) { root.navigationRequested(d) } }
}
