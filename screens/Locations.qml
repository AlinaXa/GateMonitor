import QtQuick
import QtQuick.Controls
import ".." as App
import "../components"

Item {
    id: root
    signal locationSelected(string location)
    signal gateSelected(string location, string gateId, string gateName)
    signal logSelected(int index)
    signal navigationRequested(string destination)

    property string searchQuery: ""
    property var searchResults: []
    readonly property var locations: [
        { name: "Fabrica", detail: "Platforma industrială · 6 porți", status: "BLUE" },
        { name: "Depou Berceni", detail: "București · 5 porți", status: "GREEN" },
        { name: "Depou Militari", detail: "București · 4 porți", status: "YELLOW" }
    ]
    readonly property var gates: [
        { location: "Fabrica", idv: "P001", name: "Intrare Principală" }, { location: "Fabrica", idv: "P002", name: "Acces Marfă" },
        { location: "Fabrica", idv: "P003", name: "Hala Producție" }, { location: "Fabrica", idv: "P004", name: "Depozit Materii Prime" },
        { location: "Fabrica", idv: "P005", name: "Zonă Expediție" }, { location: "Fabrica", idv: "P006", name: "Acces Tehnic" },
        { location: "Depou Berceni", idv: "P014", name: "Intrare Principală" }, { location: "Depou Berceni", idv: "P015", name: "Ieșire Service" },
        { location: "Depou Berceni", idv: "P016", name: "Acces Tehnic" }, { location: "Depou Berceni", idv: "P017", name: "Parcare Vehicule" },
        { location: "Depou Berceni", idv: "P018", name: "Spălătorie" }, { location: "Depou Militari", idv: "P021", name: "Intrare Vest" },
        { location: "Depou Militari", idv: "P022", name: "Intrare Est" }, { location: "Depou Militari", idv: "P023", name: "Atelier" },
        { location: "Depou Militari", idv: "P024", name: "Ieșire Vehicule" }
    ]

    function updateSearch() {
        var q = searchQuery.trim().toLocaleLowerCase()
        var found = []
        if (!q.length) { searchResults = found; return }
        for (var l = 0; l < locations.length; ++l) {
            var location = locations[l]
            if ((location.name + " " + location.detail).toLocaleLowerCase().indexOf(q) >= 0)
                found.push({ type: "location", title: location.name, subtitle: location.detail, meta: "Locație", location: location.name })
        }
        for (var g = 0; g < gates.length; ++g) {
            var gate = gates[g]
            if ((gate.idv + " " + gate.name + " " + gate.location + " poarta porți").toLocaleLowerCase().indexOf(q) >= 0)
                found.push({ type: "gate", title: gate.idv + " · " + gate.name, subtitle: gate.location, meta: "Poartă", location: gate.location, gateId: gate.idv, gateName: gate.name })
        }
        for (var i = 0; i < App.AppState.auditLog.count; ++i) {
            var log = App.AppState.auditLog.get(i)
            var searchable = [log.eventId, log.time, "2026", log.title, log.source, log.userName, log.technical, log.note].join(" ").toLocaleLowerCase()
            if (searchable.indexOf(q) >= 0)
                found.push({ type: "log", title: log.title, subtitle: log.source + " · " + log.time, meta: log.eventId, logIndex: i })
        }
        searchResults = found.slice(0, 30)
    }

    Rectangle { anchors.fill: parent; color: App.Theme.background }
    Column {
        anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top; anchors.bottom: nav.top
        anchors.margins: 16; anchors.topMargin: 42; spacing: 12
        Text { text: "Locații"; color: App.Theme.primaryText; font.pixelSize: 22; font.weight: Font.Bold }
        Text { text: "Selectează locația monitorizată"; color: App.Theme.secondaryText; font.pixelSize: 12 }

        TextField {
            id: searchField
            width: parent.width
            height: 46
            leftPadding: 42
            rightPadding: 38
            placeholderText: ""
            color: App.Theme.primaryText
            placeholderTextColor: App.Theme.secondaryText
            font.pixelSize: 12
            selectByMouse: true
            background: Rectangle { radius: 14; color: App.Theme.card; border.color: searchField.activeFocus ? App.Theme.blue : App.Theme.cardBorder; border.width: searchField.activeFocus ? 2 : 1 }
            Item {
                x: 15; anchors.verticalCenter: parent.verticalCenter; width: 20; height: 20
                Rectangle { x: 1; y: 1; width: 12; height: 12; radius: 6; color: "transparent"; border.color: App.Theme.blue; border.width: 2 }
                Rectangle { x: 12; y: 13; width: 8; height: 2; radius: 1; color: App.Theme.blue; rotation: 45; transformOrigin: Item.Left }
            }
            Text { visible: searchField.text.length === 0; x: 42; anchors.verticalCenter: parent.verticalCenter; text: "Caută porți, locații, loguri, date, ani…"; color: App.Theme.secondaryText; font.pixelSize: 12 }
            Text { visible: searchField.text.length > 0; anchors.right: parent.right; anchors.rightMargin: 14; anchors.verticalCenter: parent.verticalCenter; text: "×"; color: App.Theme.secondaryText; font.pixelSize: 18; MouseArea { anchors.fill: parent; anchors.margins: -8; onClicked: searchField.clear() } }
            onTextChanged: { root.searchQuery = text; root.updateSearch() }
        }

        Column {
            visible: root.searchQuery.trim().length === 0
            width: parent.width
            spacing: 12
            Repeater {
            model: root.locations
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

        ListView {
            visible: root.searchQuery.trim().length > 0
            width: parent.width
            height: parent.height - 132
            clip: true
            spacing: 8
            model: root.searchResults

            delegate: Rectangle {
                id: resultRow
                required property var modelData
                width: ListView.view.width
                height: 72
                radius: 13
                color: resultMouse.containsMouse ? App.Theme.cardHover : App.Theme.card
                border.color: App.Theme.cardBorder

                Rectangle { x: 13; anchors.verticalCenter: parent.verticalCenter; width: 36; height: 36; radius: 18; color: App.Theme.statusBackground(resultRow.modelData.type === "log" ? "YELLOW" : "BLUE", false); Text { anchors.centerIn: parent; text: resultRow.modelData.type === "location" ? "⌖" : resultRow.modelData.type === "gate" ? "◉" : "≡"; color: resultRow.modelData.type === "log" ? App.Theme.yellow : App.Theme.blue; font.pixelSize: 16 } }
                Column { x: 60; anchors.verticalCenter: parent.verticalCenter; width: parent.width - 126; spacing: 4; Text { width: parent.width; text: resultRow.modelData.title; color: App.Theme.primaryText; font.pixelSize: 12; font.weight: Font.DemiBold; elide: Text.ElideRight } Text { width: parent.width; text: resultRow.modelData.subtitle; color: App.Theme.secondaryText; font.pixelSize: 10; elide: Text.ElideRight } }
                Text { anchors.right: parent.right; anchors.rightMargin: 13; y: 13; text: resultRow.modelData.meta; color: App.Theme.blue; font.pixelSize: 9 }
                Text { anchors.right: parent.right; anchors.rightMargin: 14; anchors.bottom: parent.bottom; anchors.bottomMargin: 10; text: "›"; color: App.Theme.secondaryText; font.pixelSize: 19 }
                MouseArea { id: resultMouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: { if (resultRow.modelData.type === "location") root.locationSelected(resultRow.modelData.location); else if (resultRow.modelData.type === "gate") root.gateSelected(resultRow.modelData.location, resultRow.modelData.gateId, resultRow.modelData.gateName); else root.logSelected(resultRow.modelData.logIndex) } }
            }

            Text { visible: root.searchResults.length === 0; anchors.horizontalCenter: parent.horizontalCenter; y: 35; text: "Niciun rezultat pentru „" + root.searchQuery + "”"; color: App.Theme.secondaryText; font.pixelSize: 12 }
        }
    }
    BottomNavigation { id: nav; anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; currentItem: "dashboard"; onNavigationRequested: function(d) { root.navigationRequested(d) } }
}
