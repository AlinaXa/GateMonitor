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

    signal clicked()

    implicitWidth: 126
    implicitHeight: 158
    scale: touch.pressed ? 1.03 : 1.0

    readonly property color healthColor: systemState === "warning" ? App.Theme.yellow
                                                : systemState === "error" ? App.Theme.red
                                                : systemState === "offline" ? "#657586"
                                                : App.Theme.blue
    readonly property color topLight: accessDirection === "topToBottom" ? App.Theme.green : App.Theme.red
    readonly property color bottomLight: accessDirection === "bottomToTop" ? App.Theme.green : App.Theme.red

    Behavior on scale { NumberAnimation { duration: 110; easing.type: Easing.OutCubic } }

    Rectangle {
        id: ring
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        width: 92
        height: 92
        radius: 46
        color: Qt.rgba(root.healthColor.r, root.healthColor.g, root.healthColor.b, touch.pressed ? 0.16 : 0.08)
        border.width: touch.pressed ? 2.5 : 1.5
        border.color: root.healthColor

        Behavior on border.width { NumberAnimation { duration: 100 } }

        Item {
            anchors.centerIn: parent
            width: 64
            height: 66

            // Carcasele laterale ale porții, văzută de sus.
            Rectangle { x: 6; y: 12; width: 13; height: 42; radius: 4; color: "#C4D0DB"; opacity: 0.9 }
            Rectangle { x: 45; y: 12; width: 13; height: 42; radius: 4; color: "#C4D0DB"; opacity: 0.9 }

            // Perechile de indicatoare: sus și jos au întotdeauna aceeași culoare.
            Rectangle { x: 8; y: 3; width: 7; height: 7; radius: 4; color: root.topLight }
            Rectangle { x: 49; y: 3; width: 7; height: 7; radius: 4; color: root.topLight }
            Rectangle { x: 8; y: 56; width: 7; height: 7; radius: 4; color: root.bottomLight }
            Rectangle { x: 49; y: 56; width: 7; height: 7; radius: 4; color: root.bottomLight }

            // Brațele se întâlnesc la mijloc și se retrag orizontal când poarta se deschide.
            Rectangle {
                x: 17; y: 31; width: 15; height: 3; radius: 2; color: App.Theme.primaryText
                transform: Rotation { origin.x: 0; origin.y: 1.5; angle: root.gateOpen ? -62 : 0; Behavior on angle { NumberAnimation { duration: 180; easing.type: Easing.InOutQuad } } }
            }
            Rectangle {
                x: 32; y: 31; width: 15; height: 3; radius: 2; color: App.Theme.primaryText
                transform: Rotation { origin.x: 15; origin.y: 1.5; angle: root.gateOpen ? 62 : 0; Behavior on angle { NumberAnimation { duration: 180; easing.type: Easing.InOutQuad } } }
            }

            Text {
                anchors.centerIn: parent
                text: root.accessDirection === "bottomToTop" ? "↑" : root.accessDirection === "topToBottom" ? "↓" : "×"
                color: root.accessDirection === "blocked" ? App.Theme.red : App.Theme.green
                font.pixelSize: 12
                font.weight: Font.Bold
            }

            Rectangle {
                visible: root.validatorActive
                x: 55; y: 24; width: 8; height: 17; radius: 2
                color: App.Theme.card
                border.color: App.Theme.blue
                Rectangle { anchors.horizontalCenter: parent.horizontalCenter; y: 4; width: 4; height: 2; color: App.Theme.blue }
            }
        }
    }

    Column {
        anchors.top: ring.bottom
        anchors.topMargin: 7
        width: parent.width
        spacing: 2

        Text { width: parent.width; text: root.gateId; color: App.Theme.primaryText; font.pixelSize: 12; font.weight: Font.Bold; horizontalAlignment: Text.AlignHCenter }
        Text { width: parent.width; text: root.location; color: App.Theme.secondaryText; font.pixelSize: 9; horizontalAlignment: Text.AlignHCenter; elide: Text.ElideRight }
        Text { width: parent.width; text: root.stateText; color: root.healthColor; font.pixelSize: 9; horizontalAlignment: Text.AlignHCenter; elide: Text.ElideRight }
    }

    MouseArea {
        id: touch
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
