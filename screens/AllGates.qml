import QtQuick
import ".." as App
import "../components"

Item {
    id: root
    signal backRequested()
    signal gateSelected(string location, string gateId, string gateName)

    property var allGates: [
        { location: "Fabrica", idv: "P001", name: "Intrare Principală", state: "BLUE", label: "Activă" },
        { location: "Fabrica", idv: "P002", name: "Acces Marfă", state: "GREEN", label: "OK" },
        { location: "Fabrica", idv: "P003", name: "Hala Producție", state: "YELLOW", label: "Atenție" },
        { location: "Fabrica", idv: "P004", name: "Depozit Materii Prime", state: "GREEN", label: "OK" },
        { location: "Fabrica", idv: "P005", name: "Zonă Expediție", state: "RED", label: "Eroare" },
        { location: "Fabrica", idv: "P006", name: "Acces Tehnic", state: "BLUE", label: "Activă" },
        { location: "Depou Berceni", idv: "P014", name: "Intrare Principală", state: "BLUE", label: "Activă" },
        { location: "Depou Berceni", idv: "P015", name: "Ieșire Service", state: "GREEN", label: "OK" },
        { location: "Depou Berceni", idv: "P016", name: "Acces Tehnic", state: "YELLOW", label: "Atenție" },
        { location: "Depou Berceni", idv: "P017", name: "Parcare Vehicule", state: "GREEN", label: "OK" },
        { location: "Depou Berceni", idv: "P018", name: "Spălătorie", state: "BLUE", label: "Activă" },
        { location: "Depou Militari", idv: "P021", name: "Intrare Vest", state: "GREEN", label: "OK" },
        { location: "Depou Militari", idv: "P022", name: "Intrare Est", state: "BLUE", label: "Activă" },
        { location: "Depou Militari", idv: "P023", name: "Atelier", state: "YELLOW", label: "Atenție" },
        { location: "Depou Militari", idv: "P024", name: "Ieșire Vehicule", state: "GREEN", label: "OK" }
    ]

    Rectangle { anchors.fill: parent; color: App.Theme.background }

    Column {
        anchors.fill: parent

        Item {
            width: parent.width
            height: 98

            Text {
                x: 18
                y: 44
                text: "‹"
                color: App.Theme.primaryText
                font.pixelSize: 28
                MouseArea { anchors.fill: parent; anchors.margins: -10; onClicked: root.backRequested() }
            }

            Column {
                x: 62
                y: 39
                spacing: 3
                Text { text: "Toate porțile"; color: App.Theme.primaryText; font.pixelSize: 21; font.weight: Font.Bold }
                Text { text: root.allGates.length + " porți · 3 locații"; color: App.Theme.secondaryText; font.pixelSize: 11 }
            }
        }

        ListView {
            width: parent.width
            height: parent.height - 98
            clip: true
            spacing: 9
            bottomMargin: 18
            model: root.allGates

            delegate: Rectangle {
                id: gateRow
                required property var modelData
                width: ListView.view.width - 32
                height: 88
                x: 16
                radius: 14
                color: mouse.containsMouse ? App.Theme.cardHover : App.Theme.card
                border.color: App.Theme.cardBorder

                Rectangle {
                    x: 14
                    anchors.verticalCenter: parent.verticalCenter
                    width: 46
                    height: 46
                    radius: 23
                    color: App.Theme.statusBackground(gateRow.modelData.state, false)
                    border.color: App.Theme.statusColor(gateRow.modelData.state)
                    Text { anchors.centerIn: parent; text: gateRow.modelData.idv; color: App.Theme.primaryText; font.pixelSize: 11; font.weight: Font.Bold }
                }

                Column {
                    x: 74
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width - 142
                    spacing: 3
                    Text { width: parent.width; text: gateRow.modelData.name; color: App.Theme.primaryText; font.pixelSize: 13; font.weight: Font.DemiBold; elide: Text.ElideRight }
                    Text { width: parent.width; text: gateRow.modelData.location; color: App.Theme.secondaryText; font.pixelSize: 10; elide: Text.ElideRight }
                    Row { spacing: 6; StatusDot { status: gateRow.modelData.state } Text { text: gateRow.modelData.label; color: App.Theme.statusColor(gateRow.modelData.state); font.pixelSize: 10 } }
                }

                Text { anchors.right: parent.right; anchors.rightMargin: 16; anchors.verticalCenter: parent.verticalCenter; text: "›"; color: App.Theme.blue; font.pixelSize: 24 }

                MouseArea {
                    id: mouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.gateSelected(gateRow.modelData.location, gateRow.modelData.idv, gateRow.modelData.name)
                }
            }
        }
    }
}
