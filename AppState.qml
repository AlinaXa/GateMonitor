pragma Singleton

import QtQuick

QtObject {
    property bool authenticated: true
    property string role: "Admin"
    property string profileName: "Admin 6"
    property string profileEmail: "admin6@gatemonitor.ro"
    property string profilePhone: "+40 721 000 006"
    property string profilePosition: "Operator monitorizare"
    readonly property bool canEdit: role === "Admin"
    property var motorStates: ({ "M1": "GREEN", "M2": "YELLOW", "M3": "RED", "M4": "GREEN", "M5": "BLUE", "M6": "GREEN" })

    function signIn(email, password) {
        if (!email.length || !password.length) return false
        authenticated = true
        profileEmail = email
        return true
    }

    function signOut() { authenticated = false }

    property ListModel auditLog: ListModel {
        ListElement { eventId: "EVT-1048"; time: "28 Aug · 01:41"; title: "Verificare automată finalizată"; source: "Motor M1 · P014"; userName: "Sistem"; severity: "GREEN"; previousValue: "Verificare în curs"; newValue: "OK"; technical: "Temperatură 42°C · Vibrații 1.8 mm/s · Curent 4.2 A"; note: "Toți parametrii sunt în limite." }
        ListElement { eventId: "EVT-1047"; time: "28 Aug · 01:37"; title: "Poarta deschisă"; source: "Poarta P014"; userName: "Admin 6"; severity: "BLUE"; previousValue: "Închisă"; newValue: "Deschisă"; technical: "Durată mișcare 8.4 s · 6 motoare sincronizate"; note: "Comandă manuală din aplicație." }
        ListElement { eventId: "EVT-1046"; time: "28 Aug · 01:36"; title: "Vibrații peste limită"; source: "Motor M2 · P014"; userName: "Sistem"; severity: "YELLOW"; previousValue: "2.1 mm/s"; newValue: "4.8 mm/s"; technical: "Prag avertizare 4.0 mm/s · Temperatură 51°C"; note: "Este recomandată o inspecție." }
        ListElement { eventId: "EVT-1045"; time: "28 Aug · 01:25"; title: "Supraîncălzire detectată"; source: "Motor M3 · P014"; userName: "Sistem"; severity: "RED"; previousValue: "58°C"; newValue: "76°C"; technical: "Prag critic 70°C · Curent 6.1 A"; note: "Motor oprit automat pentru protecție." }
        ListElement { eventId: "EVT-1044"; time: "28 Aug · 01:20"; title: "Mentenanță înregistrată"; source: "Motor M5 · P014"; userName: "Admin 4"; severity: "BLUE"; previousValue: "Planificată"; newValue: "Finalizată"; technical: "Rulment verificat · Conexiuni strânse"; note: "Următoarea verificare la 12.500 cicluri." }
    }

    function motorStatus(motorId) {
        return motorStates[motorId] || "BLUE"
    }

    function setMotorStatus(motorId, status, label) {
        var updated = Object.assign({}, motorStates)
        var oldStatus = updated[motorId] || "BLUE"
        updated[motorId] = status
        motorStates = updated
        auditLog.insert(0, {
            eventId: "EVT-" + (1049 + auditLog.count),
            time: Qt.formatDateTime(new Date(), "dd MMM · hh:mm"),
            title: "Stare schimbată în " + label,
            source: "Motor " + motorId + " · P014",
            userName: profileName,
            severity: status,
            previousValue: oldStatus,
            newValue: status,
            technical: "Modificare manuală din aplicație",
            note: "Operațiune efectuată de un administrator."
        })
    }
}
