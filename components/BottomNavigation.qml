import QtQuick
import ".." as App

Rectangle {
    id: root

    property string currentItem: "gates"
    signal navigationRequested(string destination)

    implicitHeight: 72
    color: App.Theme.card
    border.color: App.Theme.cardBorder
    border.width: 1

    Row {
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8

        Repeater {
            model: [
                { key: "dashboard", label: "Dashboard", icon: "⌂" },
                { key: "gates", label: "Porți", icon: "◉" },
                { key: "alarms", label: "Alarme", icon: "!" },
                { key: "menu", label: "Meniu", icon: "≡" }
            ]

            delegate: Item {
                required property var modelData
                width: (root.width - 16) / 4
                height: parent.height

                Column {
                    anchors.centerIn: parent
                    spacing: 3

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: modelData.icon
                        color: root.currentItem === modelData.key ? App.Theme.blue : App.Theme.secondaryText
                        font.pixelSize: 18
                        font.weight: Font.DemiBold
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: modelData.label
                        color: root.currentItem === modelData.key ? App.Theme.blue : App.Theme.secondaryText
                        font.pixelSize: 10
                        font.weight: root.currentItem === modelData.key ? Font.DemiBold : Font.Normal
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.navigationRequested(modelData.key)
                }
            }
        }
    }
}
