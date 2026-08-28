pragma ComponentBehavior: Bound

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

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#071424" }
            GradientStop { position: 0.5; color: "#091827" }
            GradientStop { position: 1.0; color: "#06111D" }
        }
    }

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

        GridView {
            width: parent.width
            height: parent.height - 98
            clip: true
            cellWidth: width / 3
            cellHeight: 180
            topMargin: 14
            bottomMargin: 18
            model: root.allGates

            delegate: Item {
                id: gateCell
                required property var modelData
                required property int index
                width: GridView.view.cellWidth
                height: GridView.view.cellHeight

                GateBubble {
                    anchors.horizontalCenter: parent.horizontalCenter
                    gateId: gateCell.modelData.idv
                    location: gateCell.modelData.location
                    stateText: gateCell.modelData.state === "GREEN" || gateCell.modelData.state === "BLUE" ? "OPEN"
                               : gateCell.modelData.state === "YELLOW" ? "WARNING" : "CLOSED"
                    gateOpen: gateCell.modelData.state === "GREEN" || gateCell.modelData.state === "BLUE"
                    accessDirection: gateCell.modelData.state === "RED" || gateCell.modelData.state === "YELLOW" ? "blocked"
                                     : (gateCell.index % 2 === 0 ? "bottomToTop" : "topToBottom")
                    validatorActive: gateCell.modelData.state !== "YELLOW"
                    systemState: gateCell.modelData.state === "GREEN" ? "open"
                                 : gateCell.modelData.state === "RED" ? "closed"
                                 : gateCell.modelData.state === "YELLOW" ? "warning" : "normal"
                    onClicked: root.gateSelected(gateCell.modelData.location, gateCell.modelData.idv, gateCell.modelData.name)
                }
            }
        }
    }
}
