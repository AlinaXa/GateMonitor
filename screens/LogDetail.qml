import QtQuick
import ".." as App
import "../components"

Item {
    id: root
    property int logIndex: 0
    readonly property var entry: App.AppState.auditLog.get(logIndex)
    signal backRequested()
    Rectangle { anchors.fill: parent; color: App.Theme.background }
    Flickable { anchors.fill: parent; contentWidth: width; contentHeight: body.height + 40; clip: true
        Column { id: body; width: parent.width - 32; x: 16; y: 40; spacing: 12
            Row { width: parent.width; height: 44; spacing: 12; Text { text: "‹"; color: App.Theme.primaryText; font.pixelSize: 28; MouseArea { anchors.fill: parent; anchors.margins: -10; onClicked: root.backRequested() } } Text { text: "Detaliu eveniment"; color: App.Theme.primaryText; font.pixelSize: 21; font.weight: Font.Bold } }
            Rectangle { width: parent.width; height: 116; radius: 15; color: App.Theme.statusBackground(root.entry.severity, false); border.color: App.Theme.statusColor(root.entry.severity); border.width: 2
                StatusDot { x: 16; y: 18; status: root.entry.severity }
                Column { x: 38; y: 14; width: parent.width - 54; spacing: 5; Text { width: parent.width; text: root.entry.title; color: App.Theme.primaryText; font.pixelSize: 15; font.weight: Font.Bold; wrapMode: Text.WordWrap } Text { text: root.entry.source; color: App.Theme.secondaryText; font.pixelSize: 11 } Text { text: root.entry.time + " · " + root.entry.userName; color: App.Theme.secondaryText; font.pixelSize: 10 } Text { text: root.entry.eventId; color: App.Theme.statusColor(root.entry.severity); font.pixelSize: 10; font.weight: Font.DemiBold } }
            }
            Section { title: "Modificare"; textValue: root.entry.previousValue + "  →  " + root.entry.newValue }
            Section { title: "Date tehnice"; textValue: root.entry.technical }
            Section { title: "Observație"; textValue: root.entry.note }
            Section { title: "Trasabilitate"; textValue: "Înregistrat de " + root.entry.userName + "\nEvenimentul este păstrat permanent în jurnalul de audit." }
        }
    }
    component Section: Rectangle { required property string title; required property string textValue; width: body.width; height: sectionText.height + 54; radius: 13; color: App.Theme.card; border.color: App.Theme.cardBorder
        Text { x: 14; y: 12; text: parent.title; color: App.Theme.secondaryText; font.pixelSize: 10 }
        Text { id: sectionText; x: 14; y: 32; width: parent.width - 28; text: parent.textValue; color: App.Theme.primaryText; font.pixelSize: 12; wrapMode: Text.WordWrap; lineHeight: 1.25 }
    }
}
