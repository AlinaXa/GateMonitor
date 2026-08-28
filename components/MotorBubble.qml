import QtQuick
import ".." as App

Item {
    id: root

    required property string motorName
    required property string status
    required property string statusLabel
    required property string lastUpdated
    required property string updatedBy
    signal clicked(string motorName)

    implicitWidth: 78
    implicitHeight: 78
    width: 78
    height: 78
    scale: hitArea.pressed ? 0.97 : (hitArea.containsMouse ? 1.05 : 1.0)

    Behavior on scale {
        NumberAnimation { duration: 110; easing.type: Easing.OutCubic }
    }

    Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: App.Theme.statusBackground(root.status, hitArea.containsMouse)
        border.width: hitArea.containsMouse ? 2.5 : 2
        border.color: App.Theme.statusColor(root.status)

        Behavior on color { ColorAnimation { duration: 100 } }
        Behavior on border.width { NumberAnimation { duration: 100 } }

        Column {
            anchors.centerIn: parent
            width: parent.width - 12
            spacing: 0

            Text {
                width: parent.width
                text: root.motorName
                color: App.Theme.primaryText
                font.pixelSize: 16
                font.weight: Font.DemiBold
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                width: parent.width
                text: root.statusLabel
                color: App.Theme.statusColor(root.status)
                font.pixelSize: 10
                font.weight: Font.Medium
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
            }

            Item { width: 1; height: 3 }

            Text {
                width: parent.width
                text: root.lastUpdated
                color: App.Theme.primaryText
                font.pixelSize: 10
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                width: parent.width
                text: root.updatedBy
                color: App.Theme.secondaryText
                font.pixelSize: 10
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
            }
        }
    }

    MouseArea {
        id: hitArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked(root.motorName)
    }
}
