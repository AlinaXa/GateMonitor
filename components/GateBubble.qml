import QtQuick
import ".." as App

Item {
    id: root

    required property string gateId
    required property string location
    required property string stateText
    property bool gateOpen: false
    property string accessDirection: "blocked"
    property bool validatorActive: false
    property string systemState: "normal"
    property bool quickVisible: false

    signal clicked()

    implicitWidth: 116
    implicitHeight: 166
    scale: touch.pressed ? 1.03 : 1.0

    readonly property color healthColor: systemState === "open" ? App.Theme.green
                                                : systemState === "closed" ? App.Theme.red
                                                : systemState === "warning" ? App.Theme.yellow
                                                : systemState === "error" ? App.Theme.red
                                                : systemState === "offline" ? "#657586"
                                                : App.Theme.blue
    readonly property color topLight: accessDirection === "topToBottom" ? App.Theme.green : App.Theme.red
    readonly property color bottomLight: accessDirection === "bottomToTop" ? App.Theme.green : App.Theme.red

    Behavior on scale { NumberAnimation { duration: 110; easing.type: Easing.OutCubic } }

    Rectangle {
        anchors.centerIn: ring
        width: ring.width + 8; height: width; radius: width / 2
        color: "transparent"; border.width: 2; border.color: root.healthColor
        visible: root.systemState !== "offline"
        SequentialAnimation on opacity {
            running: root.visible && (root.systemState === "normal" || root.systemState === "error" || root.systemState === "warning")
            loops: Animation.Infinite
            NumberAnimation { from: 0.50; to: 0.05; duration: root.systemState === "error" ? 520 : 1250 }
            NumberAnimation { from: 0.05; to: 0.50; duration: root.systemState === "error" ? 520 : 1250 }
        }
    }

    Rectangle {
        id: ring
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        width: 104
        height: 104
        radius: 52
        color: "transparent"
        border.width: touch.pressed ? 2.5 : 1.5
        border.color: root.healthColor

        Behavior on border.width { NumberAnimation { duration: 100 } }

        SequentialAnimation on rotation {
            running: root.visible && root.systemState === "error"
            loops: Animation.Infinite
            PauseAnimation { duration: 1900 }
            NumberAnimation { to: -2.5; duration: 55 }
            NumberAnimation { to: 2.5; duration: 75 }
            NumberAnimation { to: -1.5; duration: 65 }
            NumberAnimation { to: 0; duration: 55 }
        }

        Item {
            anchors.centerIn: parent
            width: 74
            height: 82

            // Carcasele laterale ale porții, văzută de sus.
            Rectangle { x: 7; y: 7; width: 13; height: 57; radius: 4; color: "#D4DCE3"; border.color: "#71808F" }
            Rectangle { x: 54; y: 7; width: 13; height: 57; radius: 4; color: "#D4DCE3"; border.color: "#71808F" }

            // Perechile de indicatoare: sus și jos au întotdeauna aceeași culoare.
            Rectangle { x: 9; y: 10; width: 9; height: 9; radius: 5; color: root.topLight; border.color: "#24313D" }
            Rectangle { x: 56; y: 10; width: 9; height: 9; radius: 5; color: root.topLight; border.color: "#24313D" }
            Rectangle { x: 9; y: 51; width: 9; height: 9; radius: 5; color: root.bottomLight; border.color: "#24313D" }
            Rectangle { x: 56; y: 51; width: 9; height: 9; radius: 5; color: root.bottomLight; border.color: "#24313D" }

            // Brațele se întâlnesc la mijloc și se retrag orizontal când poarta se deschide.
            Rectangle {
                x: 20; y: 34; width: 17; height: 4; radius: 2; color: App.Theme.primaryText
                transform: Rotation { origin.x: 0; origin.y: 2; angle: root.gateOpen ? 38 : 0; Behavior on angle { NumberAnimation { duration: 180; easing.type: Easing.InOutQuad } } }
            }
            Rectangle {
                x: 37; y: 34; width: 17; height: 4; radius: 2; color: App.Theme.primaryText
                transform: Rotation { origin.x: 17; origin.y: 2; angle: root.gateOpen ? -38 : 0; Behavior on angle { NumberAnimation { duration: 180; easing.type: Easing.InOutQuad } } }
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: -1
                text: root.accessDirection === "bottomToTop" ? "↑" : root.accessDirection === "topToBottom" ? "↓" : "×"
                color: root.accessDirection === "blocked" ? App.Theme.red : App.Theme.green
                font.pixelSize: 18
                font.weight: Font.Bold
            }

            Rectangle {
                visible: root.validatorActive
                x: 58; y: 27; width: 11; height: 20; radius: 3
                color: "#102033"
                border.width: 2
                border.color: root.gateOpen ? App.Theme.green : App.Theme.red
                Text { anchors.centerIn: parent; text: "◇"; color: parent.border.color; font.pixelSize: 8 }
            }
        }
    }

    Rectangle {
        visible: root.quickVisible
        z: 20; width: 108; height: 48; radius: 10
        anchors.horizontalCenter: parent.horizontalCenter; anchors.bottom: ring.top; anchors.bottomMargin: 4
        color: "#16293A"; border.color: root.healthColor
        Column { anchors.centerIn: parent; spacing: 2
            Text { anchors.horizontalCenter: parent.horizontalCenter; text: "Detalii rapide"; color: App.Theme.primaryText; font.pixelSize: 10; font.weight: Font.DemiBold }
            Text { anchors.horizontalCenter: parent.horizontalCenter; text: root.gateId + " · " + root.stateText; color: root.healthColor; font.pixelSize: 9 }
        }
    }
    Timer { id: quickTimer; interval: 1800; onTriggered: root.quickVisible = false }

    Column {
        anchors.top: ring.bottom
        anchors.topMargin: 8
        width: parent.width
        spacing: 2

        Text { width: parent.width; text: root.gateId; color: App.Theme.primaryText; font.pixelSize: 14; font.weight: Font.Bold; horizontalAlignment: Text.AlignHCenter }
        Text { width: parent.width; text: root.location; color: App.Theme.secondaryText; font.pixelSize: 10; horizontalAlignment: Text.AlignHCenter; elide: Text.ElideRight }
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 5
            Rectangle { anchors.verticalCenter: parent.verticalCenter; width: 7; height: 7; radius: 4; color: root.healthColor }
            Text { text: root.stateText.toUpperCase(); color: root.healthColor; font.pixelSize: 10; font.weight: Font.DemiBold }
        }
    }

    MouseArea {
        id: touch
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
        onPressAndHold: { root.quickVisible = true; quickTimer.restart() }
    }
}
