import QtQuick
import ".." as App

Rectangle {
    required property string status

    implicitWidth: 8
    implicitHeight: 8
    width: 8
    height: 8
    radius: width / 2
    color: App.Theme.statusColor(status)
}
