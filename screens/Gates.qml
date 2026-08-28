import QtQuick
import ".." as App
import "../components"

Item {
    id: root
    property string locationName: "Depou Berceni"
    signal backRequested()
    signal gateSelected(string gateId, string gateName)
    signal changeLocationRequested()
    signal navigationRequested(string destination)
    Rectangle { anchors.fill: parent; color: App.Theme.background }
    Column {
        anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top; anchors.bottom: nav.top
        anchors.margins: 16; anchors.topMargin: 38; spacing: 12
        Row {
            width: parent.width; height: 44; spacing: 10
            Text { text: "‹"; color: App.Theme.primaryText; font.pixelSize: 28; width: 28; MouseArea { anchors.fill: parent; onClicked: root.backRequested() } }
            Column { width: parent.width - 92; Text { text: "Porți"; color: App.Theme.primaryText; font.pixelSize: 21; font.weight: Font.Bold } Text { text: root.locationName; color: App.Theme.secondaryText; font.pixelSize: 11 } }
            Text { text: "Schimbă"; color: App.Theme.blue; font.pixelSize: 11; anchors.verticalCenter: parent.verticalCenter; MouseArea { anchors.fill: parent; anchors.margins: -10; onClicked: root.changeLocationRequested() } }
        }
        Repeater {
            model: [
                { idv: "P014", name: "Intrare Principală", state: "BLUE", label: "Activă", time: "01:37 · Admin 6" },
                { idv: "P015", name: "Ieșire Service", state: "GREEN", label: "OK", time: "01:32 · Admin 4" },
                { idv: "P016", name: "Acces Tehnic", state: "YELLOW", label: "Atenție", time: "01:28 · Admin 7" }
            ]
            delegate: Rectangle {
                required property var modelData
                width: root.width - 32; height: 88; radius: 14; color: mouse.containsMouse ? App.Theme.cardHover : App.Theme.card; border.color: App.Theme.cardBorder
                Rectangle { x: 14; anchors.verticalCenter: parent.verticalCenter; width: 44; height: 44; radius: 22; color: App.Theme.statusBackground(modelData.state, false); border.color: App.Theme.statusColor(modelData.state); Text { anchors.centerIn: parent; text: modelData.idv; color: App.Theme.primaryText; font.pixelSize: 12; font.weight: Font.Bold } }
                Column { x: 72; anchors.verticalCenter: parent.verticalCenter; width: parent.width - 136; spacing: 4; Text { width: parent.width; text: modelData.name; color: App.Theme.primaryText; font.pixelSize: 14; font.weight: Font.DemiBold; elide: Text.ElideRight } Text { text: modelData.label; color: App.Theme.statusColor(modelData.state); font.pixelSize: 11 } Text { text: modelData.time; color: App.Theme.secondaryText; font.pixelSize: 10 } }
                Text { anchors.right: parent.right; anchors.rightMargin: 16; anchors.verticalCenter: parent.verticalCenter; text: "›"; color: App.Theme.blue; font.pixelSize: 25 }
                MouseArea { id: mouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: root.gateSelected(modelData.idv, modelData.name) }
            }
        }
    }
    BottomNavigation { id: nav; anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; currentItem: "gates"; onNavigationRequested: function(d) { root.navigationRequested(d) } }
}
