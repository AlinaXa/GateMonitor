import QtQuick
import ".." as App
import "../components"

Item {
    id: root
    signal locationSelected(string location)
    signal navigationRequested(string destination)

    Rectangle { anchors.fill: parent; color: App.Theme.background }
    Column {
        anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top; anchors.bottom: nav.top
        anchors.margins: 16; anchors.topMargin: 42; spacing: 14
        Text { text: "Locații"; color: App.Theme.primaryText; font.pixelSize: 22; font.weight: Font.Bold }
        Text { text: "Selectează locația monitorizată"; color: App.Theme.secondaryText; font.pixelSize: 12 }
        Repeater {
            model: [
                { name: "Depou Berceni", detail: "București · 4 porți", status: "BLUE" },
                { name: "Depou Militari", detail: "București · 3 porți", status: "GREEN" },
                { name: "Terminal Nord", detail: "Ploiești · 2 porți", status: "YELLOW" }
            ]
            delegate: Rectangle {
                required property var modelData
                width: root.width - 32; height: 82; radius: 14
                color: mouse.containsMouse ? App.Theme.cardHover : App.Theme.card
                border.color: App.Theme.cardBorder
                StatusDot { x: 16; anchors.verticalCenter: parent.verticalCenter; status: modelData.status }
                Column {
                    x: 38; anchors.verticalCenter: parent.verticalCenter; width: parent.width - 82; spacing: 5
                    Text { width: parent.width; text: modelData.name; color: App.Theme.primaryText; font.pixelSize: 15; font.weight: Font.DemiBold }
                    Text { width: parent.width; text: modelData.detail; color: App.Theme.secondaryText; font.pixelSize: 11 }
                }
                Text { anchors.right: parent.right; anchors.rightMargin: 16; anchors.verticalCenter: parent.verticalCenter; text: "›"; color: App.Theme.blue; font.pixelSize: 25 }
                MouseArea { id: mouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: root.locationSelected(modelData.name) }
            }
        }
    }
    BottomNavigation { id: nav; anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; currentItem: "dashboard"; onNavigationRequested: function(d) { root.navigationRequested(d) } }
}
