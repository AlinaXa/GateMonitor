pragma Singleton

import QtQuick

QtObject {
    readonly property color background: "#07121F"
    readonly property color card: "#0E1C2B"
    readonly property color cardHover: "#13263A"
    readonly property color cardBorder: "#1C3449"
    readonly property color primaryText: "#F4F7FB"
    readonly property color secondaryText: "#8EA0B3"
    readonly property color blue: "#3478F6"
    readonly property color green: "#2CCB70"
    readonly property color yellow: "#F5A623"
    readonly property color red: "#EF4444"

    function statusColor(status) {
        switch (String(status).toUpperCase()) {
        case "GREEN": return green
        case "YELLOW": return yellow
        case "RED": return red
        case "BLUE": return blue
        default: return blue
        }
    }

    function statusBackground(status, hovered) {
        var c = statusColor(status)
        return Qt.rgba(c.r, c.g, c.b, hovered ? 0.20 : 0.12)
    }
}
