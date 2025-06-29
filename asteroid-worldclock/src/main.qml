import QtQuick 2.9
import org.asteroid.controls 1.0
import QtQuick.LocalStorage 2.0
import Qt.labs.settings 1.0

Application {
    id: app

    // Page management
    property string currentPage: "mainPage"

    // Dynamic background properties
    centerColor: getTimePeriod(displayHours).center
    outerColor: getTimePeriod(displayHours).outer

    // Current displayed hour (0-23)
    property int displayHours: (new Date()).getHours()

    // Time period colors
    function getTimePeriod(hours) {
        if (hours >= 5 && hours < 10) return { center: "#0575b5", outer: "#002045" };
        else if (hours >= 10 && hours < 17) return { center: "#ffd208", outer: "#08adff" };
        else if (hours >= 17 && hours < 21) return { center: "#f78000", outer: "#3c007d" };
        else return { center: "#2e2e2e", outer: "#000000" };
    }

    // Timezone data by continent
    property var timezoneData: {
        "NAmerica": [
            { name: "ET", offset: -5, fullName: "Eastern" },
            { name: "CT", offset: -6, fullName: "Central" },
            { name: "MT", offset: -7, fullName: "Mountain" },
            { name: "PT", offset: -8, fullName: "Pacific" },
            { name: "AKT", offset: -9, fullName: "Alaska" },
            { name: "HST", offset: -11, fullName: "Hawaii" },
            { name: "AST", offset: -3, fullName: "Atlantic" },
            { name: "NST", offset: -3.5, fullName: "Newfoundland" }
        ],
        "SAmerica": [
            { name: "BRT", offset: -3, fullName: "Uruguay" },
            { name: "ART", offset: -3, fullName: "Argentina" },
            { name: "BRS", offset: -3, fullName: "Brasilia" },
            { name: "CLT", offset: -4, fullName: "West Brazil" },
            { name: "BOT", offset: -4, fullName: "Bolivia" },
            { name: "VET", offset: -4, fullName: "Venezuela" },
            { name: "PET", offset: -5, fullName: "Peru" },
            { name: "ECT", offset: -5, fullName: "Ecuador" },
            { name: "FKT", offset: -5, fullName: "Colombia" },
            { name: "PNM", offset: -6, fullName: "West Panama" }
        ],
        "Africa": [
            { name: "WAT", offset: 3, fullName: "West Africa" },
            { name: "CAT", offset: 4, fullName: "Central Africa" },
            { name: "EAT", offset: 5, fullName: "East Africa" },
            { name: "SAST", offset: 4, fullName: "South Africa" },
            { name: "GMT", offset: 3, fullName: "Greenwich" },
            { name: "MUT", offset: 6, fullName: "Mauritius" },
            { name: "SCT", offset: 6, fullName: "Seychelles" },
            { name: "LMT", offset: 2, fullName: "Liberia" }
        ],
        "Europe": [
            { name: "GMT", offset: 0, fullName: "Greenwich" },
            { name: "CET", offset: 0, fullName: "Central" },
            { name: "EET", offset: 2, fullName: "Eastern" },
            { name: "WET", offset: -1, fullName: "Western" },
            { name: "MSK", offset: 2, fullName: "Moscow" },
            { name: "TRT", offset: 2, fullName: "Turkey" },
            { name: "IST", offset: 0, fullName: "Ireland" },
            { name: "CEST", offset: 1, fullName: "Central Summer" }
        ],
        "Asia": [
            { name: "IST", offset: 5.5, fullName: "India" },
            { name: "CST", offset: 8, fullName: "China" },
            { name: "JST", offset: 9, fullName: "Japan" },
            { name: "KST", offset: 9, fullName: "Korea" },
            { name: "GST", offset: 4, fullName: "Gulf" },
            { name: "PHT", offset: 8, fullName: "Philippines" },
            { name: "ICT", offset: 7, fullName: "Indochina" },
            { name: "AZT", offset: 4, fullName: "Azerbaijan" }
        ],
        "Oceania": [
            { name: "AEST", offset: 10, fullName: "East Australia" },
            { name: "ACST", offset: 9.5, fullName: "Central Australia" },
            { name: "AWST", offset: 8, fullName: "West Australia" },
            { name: "NZST", offset: 12, fullName: "New Zealand" },
            { name: "FJT", offset: 12, fullName: "Fiji" },
            { name: "PGT", offset: 10, fullName: "Papua New Guinea" },
            { name: "CHAST", offset: 12.75, fullName: "Chatham" },
            { name: "NFT", offset: 11, fullName: "Norfolk" }
        ]
    }

    property var timezones: timezoneData[appSettings.savedContinent] || timezoneData["NAmerica"]

    // Global offset that applies to all timezones
    property int globalHourOffset: 0

    // Saved settings
    Settings {
        id: appSettings
        property int currentIndex: 0
        property int savedGlobalOffset: 0
        property string savedContinent: "NAmerica"
    }

    property var currentTime: new Date()
    property int currentIndex: appSettings.currentIndex
    property bool transitioning: false

    // Initialize with saved values
    Component.onCompleted: {
        globalHourOffset = appSettings.savedGlobalOffset
    }

    // Update time display immediately when anything changes
    function updateDisplay() {
        var displayTime = new Date(currentTime.getTime() + 
                                 (timezones[currentIndex].offset * 3600 * 1000) +
                                 (globalHourOffset * 3600 * 1000));
        displayHours = displayTime.getHours();
    }

    Timer {
        interval: 1000
        running: currentPage === "mainPage"
        repeat: true
        onTriggered: {
            currentTime = new Date();
            updateDisplay();
        }
    }

    // Main Page
    Item {
        anchors.fill: parent
        visible: currentPage === "mainPage"

        // Time display with fade transition
        Item {
            id: timeDisplayContainer
            anchors.fill: parent
            
            Column {
                id: timeDisplayContent
                anchors.centerIn: parent
                spacing: Dims.l(2)
                opacity: transitioning ? 0 : 1
                
                Behavior on opacity {
                    NumberAnimation { duration: 200 }
                }

                // Main time display (12-hour format)
                Row {
                    spacing: Dims.l(2)
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Label {
                        id: timeDisplay
                        font.pixelSize: Dims.l(20)
                        text: {
                            var time = new Date(currentTime.getTime() + 
                                              (timezones[currentIndex].offset * 3600 * 1000) +
                                              (globalHourOffset * 3600 * 1000));
                            var hours = time.getHours() % 12;
                            return (hours === 0 ? 12 : hours) + ":" + Qt.formatTime(time, "mm");
                        }
                    }

                    Label {
                        id: ampmDisplay
                        font.pixelSize: Dims.l(10)
                        anchors.verticalCenter: parent.verticalCenter
                        text: {
                            var time = new Date(currentTime.getTime() + 
                                              (timezones[currentIndex].offset * 3600 * 1000) +
                                              (globalHourOffset * 3600 * 1000));
                            return time.getHours() >= 12 ? "PM" : "AM";
                        }
                    }
                }

                // Timezone info
                Row {
                    spacing: Dims.l(3)
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Label {
                        font.pixelSize: Dims.l(6)
                        text: timezones[currentIndex].fullName
                    }
                    
                    Label {
                        font.pixelSize: Dims.l(6)
                        text: "UTC" + (timezones[currentIndex].offset >= 0 ? "+" : "") + 
                              timezones[currentIndex].offset
                    }
                }
            }
        }

        // Navigation and settings
        Column {
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
                bottomMargin: Dims.l(5)
            }
            spacing: Dims.l(2)

            Icon {
                width: Dims.l(6)
                height: Dims.l(6)
                anchors.horizontalCenter: parent.horizontalCenter
                name: "ios-arrow-up"
            }

            IconButton {
                width: Dims.l(8)
                height: Dims.l(8)
                anchors.horizontalCenter: parent.horizontalCenter
                iconName: "ios-settings"
                onClicked: currentPage = "secondPage"
            }
        }

        // Swipe handling
        MouseArea {
            anchors.fill: parent
            property real startX: 0
            property real startY: 0
            property bool swipeInProgress: false

            onPressed: {
                startX = mouse.x;
                startY = mouse.y;
                swipeInProgress = true;
            }

            onReleased: {
                swipeInProgress = false;
            }

            onPositionChanged: {
                if (swipeInProgress) {
                    var deltaX = mouse.x - startX;
                    var deltaY = mouse.y - startY;
                    
                    if (Math.abs(deltaX) > Math.abs(deltaY) && Math.abs(deltaX) > 30) {
                        if (transitioning) return;
                        
                        transitioning = true;
                        timeDisplayContent.opacity = 0;
                        
                        var changeTimer = Qt.createQmlObject('import QtQuick 2.9; Timer { interval: 200; running: true; }', parent);
                        changeTimer.triggered.connect(function() {
                            if (deltaX > 30 && currentIndex > 0) currentIndex--;
                            else if (deltaX < -30 && currentIndex < timezones.length - 1) currentIndex++;
                            
                            appSettings.currentIndex = currentIndex;
                            currentTime = new Date();
                            updateDisplay();
                            timeDisplayContent.opacity = 1;
                            transitioning = false;
                            changeTimer.destroy();
                        });
                    }
                    else if (deltaY < -30) {
                        currentPage = "secondPage";
                        swipeInProgress = false;
                    }
                }
            }
        }
    }

    // Second Page Loader
    Loader {
        id: secondPageLoader
        active: currentPage === "secondPage"
        source: "second.qml"
        anchors.fill: parent
        
        onLoaded: {
            item.parentPage = Qt.binding(function() { return app });
            item.globalHourOffset = Qt.binding(function() { return globalHourOffset });
        }
    }
}
