import QtQuick
import ".." as App

Item {
    id: root
    signal backRequested()
    property string period: "7 zile"
    Rectangle { anchors.fill: parent; color: App.Theme.background }
    Flickable {
        anchors.fill: parent; contentHeight: content.height + 34; clip: true
        Column {
            id: content; width: parent.width; spacing: 12
            Item { width: parent.width; height: 92
                Text { x: 18; y: 42; text: "‹"; color: App.Theme.primaryText; font.pixelSize: 28; MouseArea { anchors.fill: parent; anchors.margins: -10; onClicked: root.backRequested() } }
                Column { x: 62; y: 38; spacing: 2
                    Text { text: "Statistici operaționale"; color: App.Theme.primaryText; font.pixelSize: 21; font.weight: Font.Bold }
                    Text { text: "Toate locațiile · actualizare live"; color: App.Theme.secondaryText; font.pixelSize: 11 }
                }
            }
            Row { anchors.horizontalCenter: parent.horizontalCenter; spacing: 7
                Repeater { model: ["24 ore", "7 zile", "30 zile"]
                    delegate: Rectangle { required property string modelData; width: 104; height: 36; radius: 10; color: root.period === modelData ? App.Theme.statusBackground("BLUE", true) : App.Theme.card; border.color: root.period === modelData ? App.Theme.blue : App.Theme.cardBorder
                        Text { anchors.centerIn: parent; text: modelData; color: root.period === modelData ? App.Theme.blue : App.Theme.secondaryText; font.pixelSize: 10; font.weight: Font.Medium }
                        MouseArea { anchors.fill: parent; onClicked: root.period = modelData }
                    }
                }
            }
            Grid { anchors.horizontalCenter: parent.horizontalCenter; columns: 2; spacing: 8
                Repeater { model: [{v:"15",l:"Porți monitorizate",c:"BLUE"},{v:"99,4%",l:"Disponibilitate",c:"GREEN"},{v:"3",l:"Alerte active",c:"YELLOW"},{v:"18 min",l:"Timp mediu remediere",c:"RED"}]
                    delegate: Rectangle { required property var modelData; width: 174; height: 82; radius: 14; color: App.Theme.card; border.color: App.Theme.cardBorder
                        Rectangle { x: 13; y: 14; width: 7; height: 7; radius: 4; color: App.Theme.statusColor(modelData.c) }
                        Text { x: 13; y: 28; text: modelData.v; color: App.Theme.primaryText; font.pixelSize: 20; font.weight: Font.Bold }
                        Text { x: 13; y: 57; text: modelData.l; color: App.Theme.secondaryText; font.pixelSize: 9 }
                    }
                }
            }
            Rectangle { anchors.horizontalCenter: parent.horizontalCenter; width: parent.width - 32; height: 220; radius: 14; color: App.Theme.card; border.color: App.Theme.cardBorder
                Text { x: 16; y: 14; text: "Cicluri de acces"; color: App.Theme.primaryText; font.pixelSize: 13; font.weight: Font.DemiBold }
                Text { anchors.right: parent.right; anchors.rightMargin: 16; y: 15; text: root.period; color: App.Theme.blue; font.pixelSize: 10 }
                Item { id: chart; x: 18; y: 50; width: parent.width - 36; height: 138
                    Repeater { model: [42,68,54,88,62,96,73]
                        delegate: Item { required property int index; required property int modelData; x: index * chart.width / 7; width: chart.width / 7 - 6; height: chart.height
                            Rectangle { anchors.bottom: day.top; anchors.bottomMargin: 7; width: parent.width; height: modelData; radius: 5; color: App.Theme.blue; opacity: 0.35 + index * 0.06 }
                            Text { id: day; anchors.bottom: parent.bottom; anchors.horizontalCenter: parent.horizontalCenter; text: ["L","M","M","J","V","S","D"][index]; color: App.Theme.secondaryText; font.pixelSize: 9 }
                        }
                    }
                }
                Text { x: 16; anchors.bottom: parent.bottom; anchors.bottomMargin: 12; text: "Total 12.486 · +8,2% față de perioada anterioară"; color: App.Theme.green; font.pixelSize: 9 }
            }
            Rectangle { anchors.horizontalCenter: parent.horizontalCenter; width: parent.width - 32; height: 172; radius: 14; color: App.Theme.card; border.color: App.Theme.cardBorder
                Text { x: 16; y: 14; text: "Sănătatea sistemului"; color: App.Theme.primaryText; font.pixelSize: 13; font.weight: Font.DemiBold }
                Column { x: 16; y: 48; width: parent.width - 32; spacing: 13
                    Repeater { model: [{n:"Fabrica",v:98,c:"GREEN"},{n:"Depou Berceni",v:91,c:"YELLOW"},{n:"Depou Militari",v:96,c:"BLUE"}]
                        delegate: Item { required property var modelData; width: parent.width; height: 25
                            Text { text: modelData.n; color: App.Theme.secondaryText; font.pixelSize: 9 }
                            Text { anchors.right: parent.right; text: modelData.v + "%"; color: App.Theme.statusColor(modelData.c); font.pixelSize: 9; font.weight: Font.Bold }
                            Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; height: 5; radius: 3; color: "#173047"
                                Rectangle { width: parent.width * modelData.v / 100; height: parent.height; radius: 3; color: App.Theme.statusColor(modelData.c) }
                            }
                        }
                    }
                }
            }
            Rectangle { anchors.horizontalCenter: parent.horizontalCenter; width: parent.width - 32; height: 74; radius: 14; color: App.Theme.statusBackground("YELLOW", false); border.color: App.Theme.yellow
                Text { x: 15; y: 13; text: "Predicție mentenanță"; color: App.Theme.yellow; font.pixelSize: 11; font.weight: Font.Bold }
                Text { x: 15; y: 36; width: parent.width - 30; text: "Motor M2 · P014 poate necesita inspecție în 9 zile."; color: App.Theme.primaryText; font.pixelSize: 10; wrapMode: Text.WordWrap }
            }
        }
    }
}
