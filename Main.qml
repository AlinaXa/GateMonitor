import QtQuick
import QtQuick.Controls
import "." as App
import "screens"

ApplicationWindow {
    id: window
    width: 390
    height: 844
    minimumWidth: 340
    minimumHeight: 640
    visible: true
    title: qsTr("Gate Monitor")
    color: App.Theme.background

    property string selectedLocation: "Fabrica"
    property string selectedGate: "P001"
    property string selectedGateName: "Intrare Principală"

    function openRoot(component, properties) {
        stackView.clear()
        stackView.push(component, properties || {})
    }

    function handleNavigation(destination) {
        if (destination === "dashboard") openRoot(locationsComponent)
        else if (destination === "gates") openRoot(gatesComponent, { locationName: selectedLocation })
        else if (destination === "alarms") openRoot(alarmsComponent)
        else if (destination === "menu") openRoot(menuComponent)
    }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: gateDetailComponent
        pushEnter: Transition { NumberAnimation { property: "x"; from: stackView.width; to: 0; duration: 180; easing.type: Easing.OutCubic } }
        pushExit: Transition { NumberAnimation { property: "x"; from: 0; to: -stackView.width * 0.22; duration: 180 } }
        popEnter: Transition { NumberAnimation { property: "x"; from: -stackView.width * 0.22; to: 0; duration: 180 } }
        popExit: Transition { NumberAnimation { property: "x"; from: 0; to: stackView.width; duration: 180; easing.type: Easing.OutCubic } }
    }

    Component {
        id: gateDetailComponent
        GateDetail {
            gateId: window.selectedGate
            gateName: window.selectedGateName
            locationName: window.selectedLocation
            onBackRequested: {
                if (stackView.depth > 1) stackView.pop()
                else window.openRoot(gatesComponent, { locationName: window.selectedLocation })
            }
            onMotorRequested: function(motorId) {
                stackView.push(motorDetailComponent, { motorName: motorId, gateId: window.selectedGate, locationName: window.selectedLocation })
            }
            onGateRequested: stackView.push(gateInfoComponent)
            onMenuRequested: window.openRoot(menuComponent)
            onNavigationRequested: function(destination) { window.handleNavigation(destination) }
        }
    }

    Component {
        id: locationsComponent
        Locations {
            onLocationSelected: function(location) {
                window.selectedLocation = location
                window.openRoot(gatesComponent, { locationName: location })
            }
            onNavigationRequested: function(destination) { window.handleNavigation(destination) }
        }
    }

    Component {
        id: gatesComponent
        Gates {
            onBackRequested: window.openRoot(locationsComponent)
            onGateSelected: function(gateId, gateName) {
                window.selectedGate = gateId
                window.selectedGateName = gateName
                window.openRoot(gateDetailComponent)
            }
            onChangeLocationRequested: window.openRoot(locationsComponent)
            onNavigationRequested: function(destination) { window.handleNavigation(destination) }
        }
    }

    Component {
        id: motorDetailComponent
        MotorDetail {
            onBackRequested: stackView.pop()
            onOpenHistoryRequested: stackView.push(historyComponent)
        }
    }

    Component {
        id: gateInfoComponent
        GateInfo {
            gateId: window.selectedGate
            gateName: window.selectedGateName
            locationName: window.selectedLocation
            onBackRequested: stackView.pop()
            onHistoryRequested: stackView.push(historyComponent)
            onMotorRequested: function(motorId) { stackView.push(motorDetailComponent, { motorName: motorId, gateId: window.selectedGate, locationName: window.selectedLocation }) }
        }
    }

    Component {
        id: alarmsComponent
        Alarms {
            onOpenMotor: function(motorId) {
                stackView.push(motorDetailComponent, { motorName: motorId, gateId: window.selectedGate, locationName: window.selectedLocation })
            }
            onNavigationRequested: function(destination) { window.handleNavigation(destination) }
        }
    }

    Component {
        id: menuComponent
        MenuPage {
            onOpenLocations: window.openRoot(locationsComponent)
            onOpenGate: window.openRoot(gateDetailComponent)
            onOpenProfile: stackView.push(profileComponent)
            onOpenHistory: stackView.push(historyComponent)
            onNavigationRequested: function(destination) { window.handleNavigation(destination) }
        }
    }

    Component {
        id: profileComponent
        Profile { onBackRequested: stackView.pop() }
    }

    Component {
        id: historyComponent
        History {
            onBackRequested: stackView.pop()
            onLogSelected: function(index) { stackView.push(logDetailComponent, { logIndex: index }) }
        }
    }

    Component {
        id: logDetailComponent
        LogDetail { onBackRequested: stackView.pop() }
    }
}
