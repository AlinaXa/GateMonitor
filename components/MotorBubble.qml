import QtQuick
import ".." as App

Item {
    id: root

    required property string motorName
    required property string status
    required property string statusLabel
    required property string lastUpdated
    required property string updatedBy
    property int motionPhase: 0
    signal clicked(string motorName)

    implicitWidth: 78
    implicitHeight: 78
    width: 78
    height: 78
    scale: hitArea.pressed ? 0.97 : (hitArea.containsMouse ? 1.05 : 1.0)
    transform: Translate { id: drift }

    ParallelAnimation {
        running: root.visible && !hitArea.pressed
        loops: Animation.Infinite
        SequentialAnimation {
            PauseAnimation { duration: root.motionPhase * 70 }
            NumberAnimation { target: drift; property: "y"; from: 0; to: -3; duration: 720 + root.motionPhase * 45; easing.type: Easing.InOutSine }
            NumberAnimation { target: drift; property: "y"; from: -3; to: 3; duration: 1050 + root.motionPhase * 35; easing.type: Easing.InOutSine }
            NumberAnimation { target: drift; property: "y"; from: 3; to: 0; duration: 680; easing.type: Easing.InOutSine }
        }
        SequentialAnimation {
            NumberAnimation { target: drift; property: "x"; from: 0; to: root.motionPhase % 2 ? 2 : -2; duration: 1200 + root.motionPhase * 40; easing.type: Easing.InOutSine }
            NumberAnimation { target: drift; property: "x"; to: 0; duration: 1200 + root.motionPhase * 40; easing.type: Easing.InOutSine }
        }
    }

    SequentialAnimation on rotation {
        running: root.visible && root.status === "RED"
        loops: Animation.Infinite
        PauseAnimation { duration: 1500 + root.motionPhase * 130 }
        NumberAnimation { to: -3; duration: 45 }
        NumberAnimation { to: 3; duration: 65 }
        NumberAnimation { to: -2; duration: 55 }
        NumberAnimation { to: 0; duration: 45 }
    }

    Behavior on scale {
        NumberAnimation { duration: 110; easing.type: Easing.OutCubic }
    }

    Rectangle {
        anchors.centerIn: parent
        width: parent.width + 8; height: width; radius: width / 2
        color: "transparent"; border.width: 2; border.color: App.Theme.statusColor(root.status)
        visible: root.status === "RED" || root.status === "YELLOW"
        SequentialAnimation on opacity {
            running: parent.visible
            loops: Animation.Infinite
            NumberAnimation { from: 0.55; to: 0.06; duration: root.status === "RED" ? 480 : 820 }
            NumberAnimation { from: 0.06; to: 0.55; duration: root.status === "RED" ? 480 : 820 }
        }
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
