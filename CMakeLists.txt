cmake_minimum_required(VERSION 3.16)

project(GateMonitor VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.4)

set_source_files_properties(Theme.qml PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)
set_source_files_properties(AppState.qml PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)

qt_add_executable(GateMonitorApp
    main.cpp
)

qt_add_qml_module(GateMonitorApp
    URI GateMonitor
    VERSION 1.0
    QML_FILES
        Main.qml
        Theme.qml
        AppState.qml
        components/MotorBubble.qml
        components/GateBubble.qml
        components/StatusDot.qml
        components/BottomNavigation.qml
        screens/GateDetail.qml
        screens/Locations.qml
        screens/Gates.qml
        screens/AllGates.qml
        screens/MotorDetail.qml
        screens/GateInfo.qml
        screens/Alarms.qml
        screens/MenuPage.qml
        screens/Profile.qml
        screens/History.qml
        screens/LogDetail.qml
    RESOURCES
        qtquickcontrols2.conf
)

target_link_libraries(GateMonitorApp PRIVATE Qt6::Quick)

set_target_properties(GateMonitorApp PROPERTIES
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
    QT_ANDROID_PACKAGE_NAME "ro.gatemonitor.app"
    QT_ANDROID_VERSION_NAME "1.2.4"
    QT_ANDROID_VERSION_CODE 8
)

include(GNUInstallDirs)
install(TARGETS GateMonitorApp
    BUNDLE DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
