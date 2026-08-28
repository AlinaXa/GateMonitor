pragma ComponentBehavior: Bound

import QtQuick
import ".." as App
import "../components"

Item {
    id: root
    property string locationName: "Fabrica"
    readonly property var gates: locationName === "Fabrica" ? [
        { idv: "P001", name: "Intrare Principală", state: "BLUE", label: "Activă", time: "01:37 · Admin 6" },
        { idv: "P002", name: "Acces Marfă", state: "GREEN", label: "OK", time: "01:35 · Admin 4" },
        { idv: "P003", name: "Hala Producție", state: "YELLOW", label: "Atenție", time: "01:31 · Admin 7" },
        { idv: "P004", name: "Depozit Materii Prime", state: "GREEN", label: "OK", time: "01:29 · Admin 5" },
        { idv: "P005", name: "Zonă Expediție", state: "RED", label: "Eroare", time: "01:25 · Admin 6" },
        { idv: "P006", name: "Acces Tehnic", state: "BLUE", label: "Activă", time: "01:20 · Admin 4" }
    ] : locationName === "Depou Berceni" ? [
        { idv: "P014", name: "Intrare Principală", state: "BLUE", label: "Activă", time: "01:37 · Admin 6" },
        { idv: "P015", name: "Ieșire Service", state: "GREEN", label: "OK", time: "01:32 · Admin 4" },
        { idv: "P016", name: "Acces Tehnic", state: "YELLOW", label: "Atenție", time: "01:28 · Admin 7" },
        { idv: "P017", name: "Parcare Vehicule", state: "GREEN", label: "OK", time: "01:22 · Admin 5" },
        { idv: "P018", name: "Spălătorie", state: "BLUE", label: "Activă", time: "01:18 · Admin 6" }
    ] : [
        { idv: "P021", name: "Intrare Vest", state: "GREEN", label: "OK", time: "01:40 · Admin 5" },
        { idv: "P022", name: "Intrare Est", state: "BLUE", label: "Activă", time: "01:34 · Admin 6" },
        { idv: "P023", name: "Atelier", state: "YELLOW", label: "Atenție", time: "01:27 · Admin 7" },
        { idv: "P024", name: "Ieșire Vehicule", state: "GREEN", label: "OK", time: "01:19 · Admin 4" }
    ]
    signal backRequested()
    signal gateSelected(string gateId, string gateName)
    signal changeLocationRequested()
    signal navigationRequested(string destination)
    Rectangle { anchors.fill: parent; color: App.Theme.background }
    Row {
        id: header
        anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top
        anchors.leftMargin: 16; anchors.rightMargin: 16; anchors.topMargin: 38
        height: 50; spacing: 10
        Text { text: "‹"; color: App.Theme.primaryText; font.pixelSize: 28; width: 28; MouseArea { anchors.fill: parent; onClicked: root.backRequested() } }
        Column { width: parent.width - 92; Text { text: "Porți"; color: App.Theme.primaryText; font.pixelSize: 21; font.weight: Font.Bold } Text { text: root.locationName; color: App.Theme.secondaryText; font.pixelSize: 11 } }
        Text { text: "Schimbă"; color: App.Theme.blue; font.pixelSize: 11; anchors.verticalCenter: parent.verticalCenter; MouseArea { anchors.fill: parent; anchors.margins: -10; onClicked: root.changeLocationRequested() } }
    }

    GridView {
        id: gateGrid
        anchors.left: parent.left; anchors.right: parent.right
        anchors.top: header.bottom; anchors.bottom: nav.top
        anchors.leftMargin: 12; anchors.rightMargin: 12
        clip: true
        topMargin: 12; bottomMargin: 16
        readonly property int columns: width >= 350 ? 3 : 2
        cellWidth: width / columns
        cellHeight: 180
        model: root.gates

        delegate: Item {
            id: gateDelegate
            required property var modelData
            required property int index
            width: GridView.view.cellWidth
            height: GridView.view.cellHeight

            GateBubble {
                anchors.horizontalCenter: parent.horizontalCenter
                gateId: gateDelegate.modelData.idv
                location: root.locationName
                stateText: gateDelegate.modelData.label
                gateOpen: gateDelegate.modelData.state === "GREEN" || gateDelegate.modelData.state === "BLUE"
                accessDirection: gateDelegate.modelData.state === "RED" || gateDelegate.modelData.state === "YELLOW" ? "blocked" : (gateDelegate.index % 2 === 0 ? "bottomToTop" : "topToBottom")
                validatorActive: gateDelegate.modelData.state !== "YELLOW"
                systemState: gateDelegate.modelData.state === "YELLOW" ? "warning" : gateDelegate.modelData.state === "RED" ? "error" : "normal"
                onClicked: root.gateSelected(gateDelegate.modelData.idv, gateDelegate.modelData.name)
            }
        }
    }
    BottomNavigation { id: nav; anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; currentItem: "gates"; onNavigationRequested: function(d) { root.navigationRequested(d) } }
}
