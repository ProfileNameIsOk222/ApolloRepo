import QtQuick 2.9
import org.asteroid.controls 1.0
import Qt.labs.settings 1.0

Item {
    id: app

    // Current values
    property var parentPage
    property int globalHourOffset: 0
    property string currentContinent: "NAmerica"

    // Persistent settings
    Settings {
        id: appSettings
        property int savedGlobalOffset: 0
        property string savedContinent: "NAmerica"
    }

    // Continent options
    property var continents: [
        "NAmerica",
        "SAmerica",
        "Africa", 
        "Europe",
        "Asia",
        "Oceania"
    ]

    // Initialize with saved values
    Component.onCompleted: {
        currentContinent = appSettings.savedContinent
        globalHourOffset = appSettings.savedGlobalOffset
    }

    // Main content
    Column {
        anchors.centerIn: parent
        spacing: Dims.l(5)

        // Global hour offset adjustment
        Column {
            spacing: Dims.l(2)
            anchors.horizontalCenter: parent.horizontalCenter

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: Dims.l(5)
                text: "Global Hour Offset"
                color: "white"
            }

            Row {
                spacing: Dims.l(3)
                anchors.horizontalCenter: parent.horizontalCenter

                IconButton {
                    width: Dims.l(8)
                    height: Dims.l(8)
                    iconName: "ios-remove"
                    onClicked: {
                        globalHourOffset -= 1
                        appSettings.savedGlobalOffset = globalHourOffset
                        parentPage.globalHourOffset = globalHourOffset
                        parentPage.updateDisplay()
                    }
                }

                Label {
                    width: Dims.l(20)
                    font.pixelSize: Dims.l(10)
                    horizontalAlignment: Text.AlignHCenter
                    text: (globalHourOffset > 0 ? "+" : "") + globalHourOffset
                    color: "white"
                }

                IconButton {
                    width: Dims.l(8)
                    height: Dims.l(8)
                    iconName: "ios-add"
                    onClicked: {
                        globalHourOffset += 1
                        appSettings.savedGlobalOffset = globalHourOffset
                        parentPage.globalHourOffset = globalHourOffset
                        parentPage.updateDisplay()
                    }
                }
            }
        }

        // Continent selection  
        Column {
            spacing: Dims.l(2)
            anchors.horizontalCenter: parent.horizontalCenter

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: Dims.l(5)
                text: "Region"
                color: "white"
            }

            Row {
                spacing: Dims.l(3)
                anchors.horizontalCenter: parent.horizontalCenter

                IconButton {
                    width: Dims.l(8)
                    height: Dims.l(8)
                    iconName: "ios-arrow-back"
                    onClicked: {
                        var index = continents.indexOf(currentContinent);
                        currentContinent = continents[(index - 1 + continents.length) % continents.length];
                    }
                }

                Label {
                    width: Dims.l(30)
                    font.pixelSize: Dims.l(6)
                    horizontalAlignment: Text.AlignHCenter
                    text: currentContinent
                    color: "white"
                }

                IconButton {
                    width: Dims.l(8)
                    height: Dims.l(8)
                    iconName: "ios-arrow-forward"
                    onClicked: {
                        var index = continents.indexOf(currentContinent);
                        currentContinent = continents[(index + 1) % continents.length];
                    }
                }
            }
        }
    }

    // Save button - with persistent settings
    Rectangle {
        width: Dims.l(80)
        height: Dims.l(10)
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: Dims.l(8)
        }
        color: "#4CAF50"
        radius: 4

        Label {
            anchors.centerIn: parent
            text: "Press & exit to apply"
            font.pixelSize: Dims.l(5)
            color: "white"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                // Save all settings
                appSettings.savedContinent = currentContinent;
                appSettings.savedGlobalOffset = globalHourOffset;
                
                // Update main page
                parentPage.timezones = parentPage.timezoneData[currentContinent];
                parentPage.globalHourOffset = globalHourOffset;
                parentPage.currentIndex = 0;
                appSettings.currentIndex = 0;
                
                // Return to main page
                parentPage.currentPage = "mainPage";
                
                // Force immediate update
                parentPage.updateDisplay();
            }
        }
    }
}
