import QtQuick
import QtQuick.Controls
import ".." as App
import "../components"

Item {
    id: root
    property string motorName: "M1"
    property string gateId: "P014"
    property string locationName: "Depou Berceni"
    property string currentStatus: App.AppState.motorStatus(motorName)
    signal backRequested()
    signal openHistoryRequested()

    function labelFor(status) {
        if (status === "GREEN") return "OK"
        if (status === "YELLOW") return "Atenție"
        if (status === "RED") return "Eroare"
        return "Activ"
    }

    ListModel {
        id: logModel
        ListElement { time: "01:41"; eventText: "Verificare automată finalizată"; admin: "Sistem"; statusValue: "GREEN" }
        ListElement { time: "01:25"; eventText: "Stare actualizată"; admin: "Admin 6"; statusValue: "BLUE" }
        ListElement { time: "00:58"; eventText: "Inspecție motor"; admin: "Admin 4"; statusValue: "GREEN" }
    }

    Rectangle { anchors.fill: parent; color: App.Theme.background }
    Flickable {
        anchors.fill: parent; contentWidth: width; contentHeight: content.height + 30; clip: true
        Column {
            id: content; width: parent.width; spacing: 14
            Item {
                width: parent.width; height: 92
                Text { x: 18; y: 42; text: "‹"; color: App.Theme.primaryText; font.pixelSize: 28; MouseArea { anchors.fill: parent; anchors.margins: -10; onClicked: root.backRequested() } }
                Column { x: 62; y: 39; width: parent.width - 80; Text { text: "Motor " + root.motorName.substring(1); color: App.Theme.primaryText; font.pixelSize: 21; font.weight: Font.Bold } Text { text: root.gateId + " · " + root.locationName; color: App.Theme.secondaryText; font.pixelSize: 11 } }
            }
            Rectangle {
                width: parent.width - 32; height: 154; anchors.horizontalCenter: parent.horizontalCenter; radius: 16; color: App.Theme.statusBackground(root.currentStatus, false); border.width: 2; border.color: App.Theme.statusColor(root.currentStatus)
                Column { anchors.centerIn: parent; spacing: 5
                    Text { anchors.horizontalCenter: parent.horizontalCenter; text: root.motorName; color: App.Theme.primaryText; font.pixelSize: 26; font.weight: Font.Bold }
                    Text { anchors.horizontalCenter: parent.horizontalCenter; text: root.labelFor(root.currentStatus); color: App.Theme.statusColor(root.currentStatus); font.pixelSize: 14; font.weight: Font.DemiBold }
                    Text { anchors.horizontalCenter: parent.horizontalCenter; text: "Ultima actualizare 01:41"; color: App.Theme.secondaryText; font.pixelSize: 11 }
                    Text { anchors.horizontalCenter: parent.horizontalCenter; text: "Admin 6"; color: App.Theme.secondaryText; font.pixelSize: 10 }
                }
            }
            Text { x: 16; text: App.AppState.canEdit ? "Schimbă starea" : "Stare monitorizată"; color: App.Theme.primaryText; font.pixelSize: 14; font.weight: Font.DemiBold }
            Row {
                anchors.horizontalCenter: parent.horizontalCenter; spacing: 8
                visible: App.AppState.canEdit
                Repeater {
                    model: ["GREEN", "YELLOW", "RED", "BLUE"]
                    delegate: Rectangle {
                        required property string modelData
                        width: 80; height: 40; radius: 11
                        color: root.currentStatus === modelData ? App.Theme.statusBackground(modelData, true) : App.Theme.card
                        border.width: root.currentStatus === modelData ? 2 : 1; border.color: App.Theme.statusColor(modelData)
                        Row { anchors.centerIn: parent; spacing: 6; StatusDot { status: modelData } Text { text: root.labelFor(modelData); color: App.Theme.primaryText; font.pixelSize: 10 } }
                        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: { root.currentStatus = modelData; App.AppState.setMotorStatus(root.motorName, modelData, root.labelFor(modelData)); logModel.insert(0, {time: Qt.formatTime(new Date(), "hh:mm"), eventText: "Stare schimbată în " + root.labelFor(modelData), admin: App.AppState.profileName, statusValue: modelData}) } }
                    }
                }
            }
            Rectangle {
                width: parent.width - 32; height: 156; anchors.horizontalCenter: parent.horizontalCenter; radius: 14; color: App.Theme.card; border.color: App.Theme.cardBorder
                Grid { anchors.fill: parent; anchors.margins: 14; columns: 2; rowSpacing: 12; columnSpacing: 8
                    Metric { label: "Temperatură"; value: root.motorName === "M3" ? "76°C" : "42°C"; stateColor: root.motorName === "M3" ? "RED" : "GREEN" }
                    Metric { label: "Vibrații"; value: root.motorName === "M2" ? "4.8 mm/s" : "1.8 mm/s"; stateColor: root.motorName === "M2" ? "YELLOW" : "GREEN" }
                    Metric { label: "Curent"; value: "4.2 A"; stateColor: "GREEN" }
                    Metric { label: "Tensiune"; value: "230 V"; stateColor: "GREEN" }
                    Metric { label: "Cicluri"; value: "12.284"; stateColor: "BLUE" }
                    Metric { label: "Conexiune"; value: "Online"; stateColor: "GREEN" }
                }
            }
            Rectangle {
                width: parent.width - 32; height: logColumn.height + 28; anchors.horizontalCenter: parent.horizontalCenter; radius: 14; color: App.Theme.card; border.color: App.Theme.cardBorder
                Column { id: logColumn; x: 16; y: 14; width: parent.width - 32
                    Text { width: parent.width; height: 32; text: "Jurnal activitate"; color: App.Theme.primaryText; font.pixelSize: 14; font.weight: Font.DemiBold }
                    Repeater { model: logModel; delegate: Item { required property string time; required property string eventText; required property string admin; required property string statusValue; width: logColumn.width; height: 58
                        Rectangle { width: parent.width; height: 1; color: App.Theme.cardBorder }
                        StatusDot { anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter; status: statusValue }
                        Column { x: 18; anchors.verticalCenter: parent.verticalCenter; width: parent.width - 80; Text { width: parent.width; text: eventText; color: App.Theme.primaryText; font.pixelSize: 11; elide: Text.ElideRight } Text { text: admin; color: App.Theme.secondaryText; font.pixelSize: 10 } }
                        Text { anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter; text: time; color: App.Theme.secondaryText; font.pixelSize: 10 }
                    } }
                }
            }
            Rectangle { width: parent.width - 32; height: 48; anchors.horizontalCenter: parent.horizontalCenter; radius: 12; color: App.Theme.card; border.color: App.Theme.cardBorder
                Text { x: 14; anchors.verticalCenter: parent.verticalCenter; text: "Vezi istoricul tehnic complet"; color: App.Theme.primaryText; font.pixelSize: 11 }
                Text { anchors.right: parent.right; anchors.rightMargin: 14; anchors.verticalCenter: parent.verticalCenter; text: "›"; color: App.Theme.blue; font.pixelSize: 22 }
                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: root.openHistoryRequested() }
            }
        }
    }
    component Metric: Item { id: metricRoot; required property string label; required property string value; required property string stateColor; width: 157; height: 34
        StatusDot { anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter; status: metricRoot.stateColor }
        Column { x: 17; anchors.verticalCenter: parent.verticalCenter; Text { text: metricRoot.label; color: App.Theme.secondaryText; font.pixelSize: 9 } Text { text: metricRoot.value; color: App.Theme.primaryText; font.pixelSize: 11; font.weight: Font.Medium } }
    }
}
