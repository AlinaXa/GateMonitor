import QtQuick
import ".." as App
import "../components"

Item {
    id: root
    property string filter: "ALL"
    signal backRequested()
    signal logSelected(int index)
    Rectangle { anchors.fill: parent; color: App.Theme.background }
    Column { anchors.fill: parent
        Item { width: parent.width; height: 92
            Text { x: 18; y: 42; text: "‹"; color: App.Theme.primaryText; font.pixelSize: 28; MouseArea { anchors.fill: parent; anchors.margins: -10; onClicked: root.backRequested() } }
            Column { x: 62; y: 38; Text { text: "Istoric și audit"; color: App.Theme.primaryText; font.pixelSize: 21; font.weight: Font.Bold } Text { text: App.AppState.auditLog.count + " evenimente înregistrate"; color: App.Theme.secondaryText; font.pixelSize: 11 } }
        }
        Row { anchors.horizontalCenter: parent.horizontalCenter; spacing: 7
            Repeater { model: [{v:"ALL",t:"Toate"},{v:"RED",t:"Critice"},{v:"YELLOW",t:"Atenție"},{v:"BLUE",t:"Modificări"}]
                delegate: Rectangle { required property var modelData; width: 82; height: 36; radius: 10; color: root.filter === modelData.v ? App.Theme.statusBackground(modelData.v === "ALL" ? "BLUE" : modelData.v, true) : App.Theme.card; border.color: root.filter === modelData.v ? App.Theme.statusColor(modelData.v === "ALL" ? "BLUE" : modelData.v) : App.Theme.cardBorder
                    Text { anchors.centerIn: parent; text: modelData.t; color: App.Theme.primaryText; font.pixelSize: 10 }
                    MouseArea { anchors.fill: parent; onClicked: root.filter = modelData.v }
                }
            }
        }
        Item { width: 1; height: 8 }
        ListView { width: parent.width; height: parent.height - 144; clip: true; spacing: 8; model: App.AppState.auditLog
            delegate: Rectangle { required property int index; required property string time; required property string title; required property string source; required property string userName; required property string severity
                width: ListView.view.width - 32; x: 16; height: visible ? 82 : 0; visible: root.filter === "ALL" || severity === root.filter; radius: 13; color: mouse.containsMouse ? App.Theme.cardHover : App.Theme.card; border.color: App.Theme.cardBorder
                StatusDot { x: 14; y: 18; status: severity }
                Column { x: 34; y: 12; width: parent.width - 92; spacing: 4; Text { width: parent.width; text: title; color: App.Theme.primaryText; font.pixelSize: 12; font.weight: Font.DemiBold; elide: Text.ElideRight } Text { width: parent.width; text: source; color: App.Theme.secondaryText; font.pixelSize: 10; elide: Text.ElideRight } Text { text: userName; color: App.Theme.secondaryText; font.pixelSize: 10 } }
                Text { anchors.right: parent.right; anchors.rightMargin: 14; y: 14; text: time.split(" · ").pop(); color: App.Theme.secondaryText; font.pixelSize: 10 }
                Text { anchors.right: parent.right; anchors.rightMargin: 14; anchors.bottom: parent.bottom; anchors.bottomMargin: 12; text: "Detalii ›"; color: App.Theme.blue; font.pixelSize: 10 }
                MouseArea { id: mouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: root.logSelected(index) }
            }
        }
    }
}
