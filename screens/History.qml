import QtQuick
import QtQuick.Controls
import ".." as App
import "../components"

Item {
    id: root
    property string filter: "ALL"
    property string query: ""
    property string selectedDay: "Toate"
    property bool calendarOpen: false
    signal backRequested()
    signal logSelected(int index)

    function matches(title, source, userName, time, eventId, technical, severity) {
        var severityOk = filter === "ALL" || severity === filter
        var dateOk = selectedDay === "Toate" || time.indexOf(selectedDay + " Aug") === 0
        var q = query.trim().toLocaleLowerCase()
        var textOk = !q.length || [title, source, userName, time, eventId, technical, "2026"].join(" ").toLocaleLowerCase().indexOf(q) >= 0
        return severityOk && dateOk && textOk
    }

    Rectangle { anchors.fill: parent; color: App.Theme.background }
    Column {
        anchors.fill: parent
        Item { width: parent.width; height: 88
            Text { x: 18; y: 40; text: "‹"; color: App.Theme.primaryText; font.pixelSize: 28; MouseArea { anchors.fill: parent; anchors.margins: -10; onClicked: root.backRequested() } }
            Column { x: 62; y: 35; Text { text: "Istoric și audit"; color: App.Theme.primaryText; font.pixelSize: 21; font.weight: Font.Bold } Text { text: App.AppState.auditLog.count + " evenimente înregistrate"; color: App.Theme.secondaryText; font.pixelSize: 11 } }
        }
        Row { anchors.horizontalCenter: parent.horizontalCenter; spacing: 7
            TextField { id: search; width: 270; height: 42; leftPadding: 38; rightPadding: 32; placeholderText: "Caută poartă, IP, admin, dată…"; color: App.Theme.primaryText; placeholderTextColor: App.Theme.secondaryText; font.pixelSize: 10
                background: Rectangle { radius: 12; color: App.Theme.card; border.color: search.activeFocus ? App.Theme.blue : App.Theme.cardBorder }
                Text { x: 14; anchors.verticalCenter: parent.verticalCenter; text: "⌕"; color: App.Theme.blue; font.pixelSize: 16 }
                Text { visible: search.text.length; anchors.right: parent.right; anchors.rightMargin: 12; anchors.verticalCenter: parent.verticalCenter; text: "×"; color: App.Theme.secondaryText; font.pixelSize: 16; MouseArea { anchors.fill: parent; anchors.margins: -7; onClicked: search.clear() } }
                onTextChanged: root.query = text
            }
            Rectangle { width: 70; height: 42; radius: 12; color: root.calendarOpen || root.selectedDay !== "Toate" ? App.Theme.statusBackground("BLUE", true) : App.Theme.card; border.color: root.calendarOpen || root.selectedDay !== "Toate" ? App.Theme.blue : App.Theme.cardBorder
                Text { anchors.centerIn: parent; text: root.selectedDay === "Toate" ? "Calendar" : root.selectedDay + " Aug"; color: root.selectedDay === "Toate" ? App.Theme.secondaryText : App.Theme.blue; font.pixelSize: 9 }
                MouseArea { anchors.fill: parent; onClicked: root.calendarOpen = !root.calendarOpen }
            }
        }
        Rectangle { visible: root.calendarOpen; width: parent.width - 32; height: visible ? 82 : 0; anchors.horizontalCenter: parent.horizontalCenter; radius: 13; color: App.Theme.card; border.color: App.Theme.cardBorder
            Text { x: 12; y: 9; text: "August 2026"; color: App.Theme.primaryText; font.pixelSize: 10; font.weight: Font.DemiBold }
            Row { anchors.horizontalCenter: parent.horizontalCenter; y: 34; spacing: 5
                Repeater { model: ["Toate","24","25","26","27","28"]
                    delegate: Rectangle { required property string modelData; width: modelData === "Toate" ? 48 : 38; height: 34; radius: 9; color: root.selectedDay === modelData ? App.Theme.blue : "#142638"
                        Text { anchors.centerIn: parent; text: modelData; color: root.selectedDay === modelData ? "white" : App.Theme.secondaryText; font.pixelSize: 9 }
                        MouseArea { anchors.fill: parent; onClicked: { root.selectedDay = modelData; root.calendarOpen = false } }
                    }
                }
            }
        }
        Item { width: 1; height: 8 }
        Row { anchors.horizontalCenter: parent.horizontalCenter; spacing: 7
            Repeater { model: [{v:"ALL",t:"Toate"},{v:"RED",t:"Critice"},{v:"YELLOW",t:"Atenție"},{v:"BLUE",t:"Modificări"}]
                delegate: Rectangle { required property var modelData; width: 82; height: 34; radius: 10; color: root.filter === modelData.v ? App.Theme.statusBackground(modelData.v === "ALL" ? "BLUE" : modelData.v, true) : App.Theme.card; border.color: root.filter === modelData.v ? App.Theme.statusColor(modelData.v === "ALL" ? "BLUE" : modelData.v) : App.Theme.cardBorder
                    Text { anchors.centerIn: parent; text: modelData.t; color: App.Theme.primaryText; font.pixelSize: 9 }
                    MouseArea { anchors.fill: parent; onClicked: root.filter = modelData.v }
                }
            }
        }
        Item { width: 1; height: 8 }
        ListView { width: parent.width; height: parent.height - y; clip: true; spacing: 8; model: App.AppState.auditLog
            delegate: Rectangle { id: row; required property int index; required property string eventId; required property string time; required property string title; required property string source; required property string userName; required property string technical; required property string severity
                readonly property bool accepted: root.matches(title, source, userName, time, eventId, technical, severity)
                width: ListView.view.width - 32; x: 16; height: accepted ? 82 : 0; visible: accepted; radius: 13; color: mouse.pressed ? App.Theme.cardHover : App.Theme.card; border.color: App.Theme.cardBorder
                scale: mouse.pressed ? 0.985 : 1; Behavior on scale { NumberAnimation { duration: 100 } }
                StatusDot { x: 14; y: 18; status: row.severity }
                Column { x: 34; y: 12; width: parent.width - 92; spacing: 4; Text { width: parent.width; text: row.title; color: App.Theme.primaryText; font.pixelSize: 12; font.weight: Font.DemiBold; elide: Text.ElideRight } Text { width: parent.width; text: row.source; color: App.Theme.secondaryText; font.pixelSize: 10; elide: Text.ElideRight } Text { text: row.userName; color: App.Theme.secondaryText; font.pixelSize: 10 } }
                Text { anchors.right: parent.right; anchors.rightMargin: 14; y: 14; text: row.time.split(" · ").pop(); color: App.Theme.secondaryText; font.pixelSize: 10 }
                Text { anchors.right: parent.right; anchors.rightMargin: 14; anchors.bottom: parent.bottom; anchors.bottomMargin: 12; text: "Detalii ›"; color: App.Theme.blue; font.pixelSize: 10 }
                MouseArea { id: mouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: root.logSelected(row.index) }
            }
        }
    }
}
