import QtQuick
import ".." as App

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

        GridView {
            width: parent.width
            height: parent.height - 98
            clip: true
            cellWidth: width / 2
            cellHeight: 184
            topMargin: 8
            bottomMargin: 18
            model: root.allGates

            delegate: Item {
                id: gateCell
                required property var modelData
                required property int index
                width: GridView.view.cellWidth
                height: GridView.view.cellHeight

                property real floatOffset: 0

                SequentialAnimation on floatOffset {
                    running: true
                    loops: Animation.Infinite
                    PauseAnimation { duration: gateCell.index * 45 }
                    NumberAnimation { to: -7; duration: 1350 + (gateCell.index % 4) * 120; easing.type: Easing.InOutSine }
                    NumberAnimation { to: 7; duration: 1350 + (gateCell.index % 4) * 120; easing.type: Easing.InOutSine }
                }

                Item {
                    id: floatingGate
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: 5 + gateCell.floatOffset
                    width: 142
                    height: 170
                    scale: mouse.pressed ? 0.94 : (mouse.containsMouse ? 1.04 : 1)

                    Behavior on scale { NumberAnimation { duration: 130; easing.type: Easing.OutCubic } }

                    Rectangle {
                        id: bubble
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 118
                        height: 118
                        radius: 59
                        color: App.Theme.statusBackground(gateCell.modelData.state, mouse.containsMouse)
                        border.width: mouse.containsMouse ? 3 : 2
                        border.color: App.Theme.statusColor(gateCell.modelData.state)

                        Rectangle {
                            anchors.centerIn: parent
                            width: 74
                            height: 48
                            radius: 12
                            color: "transparent"
                            border.width: 2
                            border.color: App.Theme.statusColor(gateCell.modelData.state)

                            // Poartă de metrou văzută de sus: două canaturi și culoar central.
                            Rectangle { x: 12; y: 5; width: 5; height: 38; radius: 2; color: App.Theme.primaryText }
                            Rectangle { anchors.right: parent.right; anchors.rightMargin: 12; y: 5; width: 5; height: 38; radius: 2; color: App.Theme.primaryText }
                            Rectangle { anchors.centerIn: parent; width: 24; height: 2; color: App.Theme.statusColor(gateCell.modelData.state) }
                            Rectangle { x: 5; anchors.verticalCenter: parent.verticalCenter; width: 10; height: 2; color: App.Theme.statusColor(gateCell.modelData.state) }
                            Rectangle { anchors.right: parent.right; anchors.rightMargin: 5; anchors.verticalCenter: parent.verticalCenter; width: 10; height: 2; color: App.Theme.statusColor(gateCell.modelData.state) }
                        }

                        Rectangle {
                            anchors.right: parent.right
                            anchors.rightMargin: 7
                            anchors.top: parent.top
                            anchors.topMargin: 8
                            width: 17
                            height: 17
                            radius: 9
                            color: App.Theme.statusColor(gateCell.modelData.state)
                            border.width: 3
                            border.color: App.Theme.background
                        }

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 10
                            text: gateCell.modelData.idv
                            color: App.Theme.primaryText
                            font.pixelSize: 13
                            font.weight: Font.Bold
                        }
                    }

                    Column {
                        anchors.top: bubble.bottom
                        anchors.topMargin: 7
                        width: parent.width
                        spacing: 2
                        Text { width: parent.width; text: gateCell.modelData.name; color: App.Theme.primaryText; font.pixelSize: 11; font.weight: Font.DemiBold; horizontalAlignment: Text.AlignHCenter; elide: Text.ElideRight }
                        Text { width: parent.width; text: gateCell.modelData.location; color: App.Theme.statusColor(gateCell.modelData.state); font.pixelSize: 10; horizontalAlignment: Text.AlignHCenter; elide: Text.ElideRight }
                    }

                    MouseArea {
                        id: mouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.gateSelected(gateCell.modelData.location, gateCell.modelData.idv, gateCell.modelData.name)
                    }
                }
            }
        }
    }
}
