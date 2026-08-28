pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import ".." as App
import "../components"

Item {
    id: root
    property string gateId: "P014"
    property string gateName: "Intrare Principală"
    property string locationName: "Depou Berceni"
    property string currentTab: "summary"
    property bool diagnosticRunning: false
    property string diagnosticStatus: "Neverificat"
    readonly property int numericId: Math.max(1, parseInt(gateId.replace(/[^0-9]/g, "")) || 1)
    readonly property string ipAddress: "10.24." + (numericId % 10 + 10) + "." + (numericId + 20)
    readonly property string macAddress: "A4:6B:C8:2F:" + (numericId < 10 ? "0" : "") + numericId + ":7D"
    readonly property string hostname: "gate-" + locationName.toLocaleLowerCase().replace(/[^a-z0-9]/g, "-") + "-" + gateId.toLocaleLowerCase()
    signal backRequested()
    signal historyRequested()
    signal motorRequested(string motorId)

    Rectangle { anchors.fill: parent; color: App.Theme.background }
    Timer { id: diagnosticTimer; interval: 1200; onTriggered: { root.diagnosticRunning = false; root.diagnosticStatus = "Online · 18 ms" } }

    Column {
        anchors.fill: parent
        Item { width: parent.width; height: 92
            Text { x: 18; y: 42; text: "‹"; color: App.Theme.primaryText; font.pixelSize: 28; MouseArea { anchors.fill: parent; anchors.margins: -10; onClicked: root.backRequested() } }
            Column { x: 62; y: 38; spacing: 2; Text { text: "Pașaport tehnic"; color: App.Theme.primaryText; font.pixelSize: 21; font.weight: Font.Bold } Text { text: root.gateId + " · " + root.locationName; color: App.Theme.secondaryText; font.pixelSize: 11 } }
        }
        Row { anchors.horizontalCenter: parent.horizontalCenter; spacing: 7
            Repeater { model: [{v:"summary",t:"Rezumat"},{v:"network",t:"Rețea"},{v:"service",t:"Service"}]
                delegate: Rectangle { id: tabButton; required property var modelData; width: 104; height: 36; radius: 10; color: root.currentTab === modelData.v ? App.Theme.statusBackground("BLUE", true) : App.Theme.card; border.color: root.currentTab === modelData.v ? App.Theme.blue : App.Theme.cardBorder
                    Text { anchors.centerIn: parent; text: tabButton.modelData.t; color: root.currentTab === tabButton.modelData.v ? App.Theme.primaryText : App.Theme.secondaryText; font.pixelSize: 10; font.weight: Font.Medium }
                    MouseArea { anchors.fill: parent; onClicked: root.currentTab = tabButton.modelData.v }
                }
            }
        }
        Item { width: 1; height: 10 }
        Flickable { width: parent.width; height: parent.height - 138; contentWidth: width; contentHeight: content.height + 28; clip: true; boundsBehavior: Flickable.StopAtBounds; ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }
            Column { id: content; width: parent.width - 32; x: 16; spacing: 10
                Rectangle { width: parent.width; height: 84; radius: 15; color: App.Theme.statusBackground("BLUE", false); border.color: App.Theme.blue
                    Column { x: 15; anchors.verticalCenter: parent.verticalCenter; spacing: 4; Text { text: root.gateId + " · " + root.gateName; color: App.Theme.primaryText; font.pixelSize: 16; font.weight: Font.Bold } Text { text: "Online · ultima comunicare acum 12 secunde"; color: App.Theme.green; font.pixelSize: 10 } Text { text: root.locationName + " · Zona acces principal"; color: App.Theme.secondaryText; font.pixelSize: 10 } }
                    StatusDot { anchors.right: parent.right; anchors.rightMargin: 17; anchors.verticalCenter: parent.verticalCenter; status: "GREEN" }
                }
                Column { visible: root.currentTab === "summary"; width: parent.width; spacing: 10
                    SectionCard { title: "Identificare"; rows: [{a:"Model",b:"GM MetroGate X6"},{a:"Serie",b:"GMX6-2024-" + root.gateId},{a:"Firmware",b:"4.8.2 · actualizat"},{a:"Instalată",b:"14 Feb 2024"}] }
                    SectionCard { title: "Operare"; rows: [{a:"Stare",b:"Activă · deschisă"},{a:"Motoare",b:"6 conectate"},{a:"Cicluri",b:"48.921"},{a:"Uptime",b:"99,96% · 47 zile"}] }
                    ActionRow { label: "Istoric complet și audit"; detail: "Alarme, comenzi și modificări"; onClicked: root.historyRequested() }
                }
                Column { visible: root.currentTab === "network"; width: parent.width; spacing: 10
                    SectionCard { title: "Adresare"; rows: [{a:"IP",b:root.ipAddress},{a:"Port",b:"502 / Modbus TCP"},{a:"MAC",b:root.macAddress},{a:"Hostname",b:root.hostname}] }
                    SectionCard { title: "Conectivitate"; rows: [{a:"Ultimul contact",b:"acum 12 sec"},{a:"Latență",b:"18 ms"},{a:"Pierderi",b:"0,02%"},{a:"Gateway",b:"10.24.10.1"}] }
                    Rectangle { width: parent.width; height: 58; radius: 13; color: App.Theme.statusBackground(root.diagnosticStatus.indexOf("Online") >= 0 ? "GREEN" : "BLUE", false); border.color: App.Theme.statusColor(root.diagnosticStatus.indexOf("Online") >= 0 ? "GREEN" : "BLUE")
                        Text { x: 14; anchors.verticalCenter: parent.verticalCenter; text: root.diagnosticRunning ? "Diagnostic în curs…" : "Test conexiune"; color: App.Theme.primaryText; font.pixelSize: 12; font.weight: Font.DemiBold }
                        Text { anchors.right: parent.right; anchors.rightMargin: 14; anchors.verticalCenter: parent.verticalCenter; text: root.diagnosticRunning ? "•••" : root.diagnosticStatus; color: root.diagnosticStatus.indexOf("Online") >= 0 ? App.Theme.green : App.Theme.blue; font.pixelSize: 10 }
                        MouseArea { anchors.fill: parent; enabled: !root.diagnosticRunning; onClicked: { root.diagnosticRunning = true; root.diagnosticStatus = "Se verifică IP, port și controler"; diagnosticTimer.restart() } }
                    }
                }
                Column { visible: root.currentTab === "service"; width: parent.width; spacing: 10
                    SectionCard { title: "Mentenanță"; rows: [{a:"Ultima revizie",b:"12 Iun 2026"},{a:"Următoarea",b:"12 Sep 2026"},{a:"Responsabil",b:"Echipa Tehnică B6"},{a:"Prioritate",b:"Normală"}] }
                    SectionCard { title: "Senzori"; rows: [{a:"Temperatură",b:"42°C · normal"},{a:"Vibrații",b:"1,8 mm/s"},{a:"Consum",b:"4,2 A"},{a:"Cicluri rămase",b:"~11.079"}] }
                    ActionRow { label: "Deschide motorul M1"; detail: "Diagnostic individual și parametri"; onClicked: root.motorRequested("M1") }
                    ActionRow { label: "Jurnal intervenții"; detail: "Operațiuni și observații tehnice"; onClicked: root.historyRequested() }
                }
            }
        }
    }

    component SectionCard: Rectangle { id: sectionRoot; required property string title; required property var rows; width: content.width; height: sectionBody.height + 42; radius: 13; color: App.Theme.card; border.color: App.Theme.cardBorder
        Text { x: 14; y: 11; text: parent.title; color: App.Theme.blue; font.pixelSize: 10; font.weight: Font.DemiBold }
        Column { id: sectionBody; x: 14; y: 32; width: parent.width - 28
            Repeater { model: sectionRoot.rows; delegate: Item { id: sectionRow; required property var modelData; width: sectionBody.width; height: 34
                Text { anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter; text: sectionRow.modelData.a; color: App.Theme.secondaryText; font.pixelSize: 10 }
                Text { anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter; width: parent.width * 0.62; horizontalAlignment: Text.AlignRight; elide: Text.ElideMiddle; text: sectionRow.modelData.b; color: App.Theme.primaryText; font.pixelSize: 10; font.weight: Font.Medium }
                Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; height: 1; color: App.Theme.cardBorder; opacity: 0.55 }
            } }
        }
    }
    component ActionRow: Rectangle { id: actionRoot; required property string label; required property string detail; signal clicked(); width: content.width; height: 62; radius: 12; color: actionMouse.containsMouse ? App.Theme.cardHover : App.Theme.card; border.color: App.Theme.cardBorder
        Column { x: 14; anchors.verticalCenter: parent.verticalCenter; spacing: 4; Text { text: actionRoot.label; color: App.Theme.primaryText; font.pixelSize: 11; font.weight: Font.DemiBold } Text { text: actionRoot.detail; color: App.Theme.secondaryText; font.pixelSize: 9 } }
        Text { anchors.right: parent.right; anchors.rightMargin: 14; anchors.verticalCenter: parent.verticalCenter; text: "›"; color: App.Theme.blue; font.pixelSize: 20 }
        MouseArea { id: actionMouse; anchors.fill: parent; hoverEnabled: true; onClicked: actionRoot.clicked() }
    }
}
