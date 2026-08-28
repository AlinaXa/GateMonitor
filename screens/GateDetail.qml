import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ".." as App
import "../components"

Item {
    id: root

    property string gateId: "P014"
    property string gateName: "Intrare Principală"
    property string locationName: "Depou Berceni"
    signal backRequested()
    signal menuRequested()
    signal gateRequested(string gateId)
    signal motorRequested(string motorId)
    signal navigationRequested(string destination)

    ListModel {
        id: motorsModel
        ListElement { motorName: "M1"; statusValue: "GREEN"; statusLabel: "OK"; lastUpdated: "01:41"; updatedBy: "Admin 6"; px: 0.50; py: 0.13 }
        ListElement { motorName: "M2"; statusValue: "YELLOW"; statusLabel: "Atenție"; lastUpdated: "01:36"; updatedBy: "Admin 7"; px: 0.78; py: 0.32 }
        ListElement { motorName: "M3"; statusValue: "RED"; statusLabel: "Eroare"; lastUpdated: "01:25"; updatedBy: "Admin 6"; px: 0.78; py: 0.68 }
        ListElement { motorName: "M4"; statusValue: "GREEN"; statusLabel: "OK"; lastUpdated: "01:30"; updatedBy: "Admin 5"; px: 0.50; py: 0.87 }
        ListElement { motorName: "M5"; statusValue: "BLUE"; statusLabel: "Activ"; lastUpdated: "01:20"; updatedBy: "Admin 4"; px: 0.22; py: 0.68 }
        ListElement { motorName: "M6"; statusValue: "GREEN"; statusLabel: "OK"; lastUpdated: "01:39"; updatedBy: "Admin 7"; px: 0.22; py: 0.32 }
    }

    Rectangle {
        anchors.fill: parent
        color: App.Theme.background
    }

    Flickable {
        id: scrollView
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: bottomNavigation.top
        contentWidth: width
        contentHeight: contentColumn.height + 24
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

        Column {
            id: contentColumn
            width: scrollView.width

            Item {
                width: parent.width
                height: 92

                Rectangle {
                    x: 16
                    y: 38
                    width: 38
                    height: 38
                    radius: 12
                    color: backMouse.containsMouse ? App.Theme.cardHover : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: "‹"
                        color: App.Theme.primaryText
                        font.pixelSize: 28
                    }

                    MouseArea {
                        id: backMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.backRequested()
                    }
                }

                Column {
                    anchors.left: parent.left
                    anchors.leftMargin: 66
                    anchors.right: parent.right
                    anchors.rightMargin: 58
                    y: 38
                    spacing: 2

                    Text {
                        width: parent.width
                        text: "Poarta " + root.gateId
                        color: App.Theme.primaryText
                        font.pixelSize: 21
                        font.weight: Font.DemiBold
                        elide: Text.ElideRight
                    }
                    Text {
                        width: parent.width
                        text: root.gateName + " · " + root.locationName
                        color: App.Theme.secondaryText
                        font.pixelSize: 12
                        elide: Text.ElideRight
                    }
                }

                Rectangle {
                    x: parent.width - 54
                    y: 38
                    width: 38
                    height: 38
                    radius: 12
                    color: menuMouse.containsMouse ? App.Theme.cardHover : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: "⋯"
                        color: App.Theme.secondaryText
                        font.pixelSize: 22
                    }
                    MouseArea {
                        id: menuMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.menuRequested()
                    }
                }
            }

            Rectangle {
                width: parent.width - 32
                height: 78
                anchors.horizontalCenter: parent.horizontalCenter
                radius: 14
                color: App.Theme.card
                border.color: App.Theme.cardBorder

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 16

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 5
                        Text { text: "Status poartă"; color: App.Theme.secondaryText; font.pixelSize: 12 }
                        RowLayout {
                            spacing: 7
                            StatusDot { status: "BLUE" }
                            Text { text: "Activă"; color: App.Theme.primaryText; font.pixelSize: 14; font.weight: Font.DemiBold }
                        }
                    }

                    Rectangle { Layout.preferredWidth: 1; Layout.fillHeight: true; color: App.Theme.cardBorder }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        Text { text: "Ultima actualizare"; color: App.Theme.secondaryText; font.pixelSize: 12 }
                        Text { text: "28 Aug · 01:37"; color: App.Theme.primaryText; font.pixelSize: 13; font.weight: Font.Medium }
                        Text { text: "de Admin 6"; color: App.Theme.secondaryText; font.pixelSize: 10 }
                    }
                }
            }

            Item { width: 1; height: 14 }

            Item {
                id: radialArea
                width: Math.min(parent.width, 390)
                height: 390
                anchors.horizontalCenter: parent.horizontalCenter

                Canvas {
                    anchors.fill: parent
                    opacity: 0.55
                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.reset()
                        ctx.strokeStyle = App.Theme.cardBorder
                        ctx.lineWidth = 1.2
                        var cx = width / 2
                        var cy = height / 2
                        for (var i = 0; i < motorsModel.count; ++i) {
                            var entry = motorsModel.get(i)
                            ctx.beginPath()
                            ctx.moveTo(cx, cy)
                            ctx.lineTo(entry.px * width, entry.py * height)
                            ctx.stroke()
                        }
                    }
                    onWidthChanged: requestPaint()
                    onHeightChanged: requestPaint()
                }

                Repeater {
                    model: motorsModel

                    delegate: MotorBubble {
                        required property int index
                        readonly property var motorData: motorsModel.get(index)

                        motorName: motorData.motorName
                        status: motorData.statusValue
                        statusLabel: motorData.statusLabel
                        lastUpdated: motorData.lastUpdated
                        updatedBy: motorData.updatedBy
                        motionPhase: index
                        x: motorData.px * radialArea.width - width / 2
                        y: motorData.py * radialArea.height - height / 2
                        onClicked: function(selectedMotor) { root.motorRequested(selectedMotor) }
                    }
                }

                Item {
                    id: gateBubble
                    width: 126
                    height: 126
                    anchors.centerIn: parent
                    scale: gateMouse.pressed ? 0.97 : (gateMouse.containsMouse ? 1.05 : 1.0)

                    Behavior on scale { NumberAnimation { duration: 110; easing.type: Easing.OutCubic } }

                    Rectangle {
                        anchors.fill: parent
                        radius: width / 2
                        color: App.Theme.statusBackground("BLUE", gateMouse.containsMouse)
                        border.width: gateMouse.containsMouse ? 3 : 2.5
                        border.color: App.Theme.blue

                        Column {
                            anchors.centerIn: parent
                            width: parent.width - 20
                            spacing: 1

                            Text { width: parent.width; text: root.gateId; color: App.Theme.primaryText; font.pixelSize: 20; font.weight: Font.Bold; horizontalAlignment: Text.AlignHCenter }
                            Text { width: parent.width; text: root.gateName; color: App.Theme.blue; font.pixelSize: 10; font.weight: Font.Medium; horizontalAlignment: Text.AlignHCenter; elide: Text.ElideRight }
                            Item { width: 1; height: 5 }
                            Text { width: parent.width; text: "01:37"; color: App.Theme.primaryText; font.pixelSize: 11; horizontalAlignment: Text.AlignHCenter }
                            Text { width: parent.width; text: "Admin 6"; color: App.Theme.secondaryText; font.pixelSize: 10; horizontalAlignment: Text.AlignHCenter }
                        }
                    }

                    MouseArea {
                        id: gateMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.gateRequested(root.gateId)
                    }
                }
            }

            InfoCard {
                title: "Alarme active"
                entries: [
                    { leading: "Motor 3", detail: "Supraîncălzire", trailing: "01:25", status: "RED" },
                    { leading: "Motor 2", detail: "Vibrații peste limită", trailing: "01:36", status: "YELLOW" }
                ]
            }

            Item { width: 1; height: 12 }

            InfoCard {
                title: "Istoric recent"
                entries: [
                    { leading: "01:37", detail: "Poarta deschisă", trailing: "Admin 6", status: "BLUE" },
                    { leading: "01:30", detail: "Motor 6 OK", trailing: "Admin 7", status: "GREEN" },
                    { leading: "01:20", detail: "Mentenanță Motor 5", trailing: "Admin 4", status: "BLUE" }
                ]
            }

            Item { width: 1; height: 20 }
        }
    }

    component InfoCard: Rectangle {
        id: infoCard
        required property string title
        required property var entries

        width: root.width - 32
        height: infoContent.height + 28
        anchors.horizontalCenter: parent.horizontalCenter
        radius: 14
        color: App.Theme.card
        border.color: App.Theme.cardBorder

        Column {
            id: infoContent
            x: 16
            y: 14
            width: parent.width - 32
            spacing: 0

            Text {
                width: parent.width
                height: 28
                text: infoCard.title
                color: App.Theme.primaryText
                font.pixelSize: 14
                font.weight: Font.DemiBold
            }

            Repeater {
                model: infoCard.entries
                delegate: Item {
                    required property var modelData
                    width: infoContent.width
                    height: 50

                    Rectangle {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 1
                        color: App.Theme.cardBorder
                    }

                    StatusDot {
                        x: 0
                        anchors.verticalCenter: parent.verticalCenter
                        status: modelData.status
                    }

                    Column {
                        x: 18
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - 100
                        spacing: 2
                        Text { width: parent.width; text: modelData.leading; color: App.Theme.primaryText; font.pixelSize: 12; font.weight: Font.Medium; elide: Text.ElideRight }
                        Text { width: parent.width; text: modelData.detail; color: App.Theme.secondaryText; font.pixelSize: 11; elide: Text.ElideRight }
                    }

                    Text {
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        width: 74
                        text: modelData.trailing
                        color: App.Theme.secondaryText
                        font.pixelSize: 11
                        horizontalAlignment: Text.AlignRight
                        elide: Text.ElideRight
                    }
                }
            }
        }
    }

    BottomNavigation {
        id: bottomNavigation
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        currentItem: "gates"
        onNavigationRequested: function(destination) { root.navigationRequested(destination) }
    }
}
