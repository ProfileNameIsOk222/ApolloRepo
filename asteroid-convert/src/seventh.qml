import QtQuick 2.9
import org.asteroid.controls 1.0

Application {
    id: app

    centerColor: "#fa8072"
    outerColor: "#c96659"
    property string currentPage: "seventhPage"
    visible: currentPage === "seventhPage"

    property string displayText: "0"
    property bool isConversionMode: false
    property real inputValue: 0
    property string selectedUnit: ""
    property string baseUnit: "tsp"

    // Clickable header
    Rectangle {
        width: 180
        height: 40
        radius: 20
        color: "#ffb6a8"
        anchors {
            top: parent.top
            topMargin: 20
            horizontalCenter: parent.horizontalCenter
        }
        border.color: "#000000"
        border.width: 2

        Label {
            anchors.centerIn: parent
            text: "Cooking Converter"
            color: "#000000"
            font.pixelSize: 16
            font.bold: true
        }

        MouseArea {
            anchors.fill: parent
            onClicked: currentPage = "menuPage"
        }
    }

    // Display
    Label {
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: grid.top
            bottomMargin: 20
        }
        text: displayText
        color: "#FFFFFF"
        font.pixelSize: 50
    }

    // Button grid
    Grid {
        id: grid
        rows: isConversionMode ? 2 : 2
        columns: isConversionMode ? 3 : 5
        spacing: 8
        anchors {
            bottom: parent.bottom
            bottomMargin: isConversionMode ? 120 : 120
            horizontalCenter: parent.horizontalCenter
        }

        Repeater {
            model: isConversionMode 
                ? ["tsp", "tbsp", "cups", "mL", "fl oz", "g"]
                : ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
            
            delegate: Rectangle {
                width: 50
                height: 50
                color: "#ffb6a8"
                radius: 8
                border.color: "#000000"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (isConversionMode) {
                            selectedUnit = modelData;
                            convertValue();
                        } else {
                            if (displayText === "0" && modelData !== ".") {
                                displayText = modelData;
                            } else {
                                displayText += modelData;
                            }
                            inputValue = parseFloat(displayText);
                        }
                    }
                }

                Label {
                    anchors.centerIn: parent
                    text: modelData
                    color: "#000000"
                    font.pixelSize: 18
                }
            }
        }
    }

    // Bottom buttons
    Row {
        spacing: 10
        anchors {
            bottom: parent.bottom
            bottomMargin: isConversionMode ? 60 : 60
            horizontalCenter: parent.horizontalCenter
        }

        Rectangle {
            width: 60
            height: 40
            color: "#ffb6a8"
            radius: 8
            border.color: "#000000"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (isConversionMode) {
                        isConversionMode = false;
                        displayText = String(inputValue);
                    } else if (!displayText.includes(".")) {
                        displayText += ".";
                    }
                }
            }

            Label {
                anchors.centerIn: parent
                text: isConversionMode ? "Back" : "."
                color: "#000000"
                font.pixelSize: 16
            }
        }

        Rectangle {
            width: 60
            height: 40
            color: "#ffb6a8"
            radius: 8
            border.color: "#000000"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    displayText = "0";
                    inputValue = 0;
                }
            }

            Label {
                anchors.centerIn: parent
                text: "C"
                color: "#000000"
                font.pixelSize: 16
            }
        }

        Rectangle {
            width: 60
            height: 40
            color: "#ffb6a8"
            radius: 8
            border.color: "#000000"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    isConversionMode = true;
                    inputValue = parseFloat(displayText);
                }
            }

            Label {
                anchors.centerIn: parent
                text: ">"
                color: "#000000"
                font.pixelSize: 16
            }
        }

        Rectangle {
            width: 90
            height: 40
            color: "#ffb6a8"
            radius: 8
            border.color: "#000000"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    const units = ["tsp", "tbsp", "cups", "mL", "fl oz", "g"];
                    const currentIndex = units.indexOf(baseUnit);
                    baseUnit = units[(currentIndex + 1) % units.length];
                }
            }

            Label {
                anchors.centerIn: parent
                text: "Base: " + baseUnit
                color: "#000000"
                font.pixelSize: 14
            }
        }
    }

    function convertValue() {
        // First convert input to teaspoons
        let valueInTsp;
        switch (baseUnit) {
            case "tsp": valueInTsp = inputValue; break;
            case "tbsp": valueInTsp = inputValue * 3; break;      // 1 tbsp = 3 tsp
            case "cups": valueInTsp = inputValue * 48; break;     // 1 cup = 48 tsp
            case "mL": valueInTsp = inputValue * 4.92892; break;  // 1 mL ≈ 4.92892 tsp
            case "fl oz": valueInTsp = inputValue * 6; break;     // 1 fl oz = 6 tsp
            case "g": valueInTsp = inputValue * 5.69; break;      // 1 g ≈ 5.69 tsp (water)
        }
        
        // Then convert from teaspoons to selected unit
        let result;
        switch (selectedUnit) {
            case "tsp": result = valueInTsp; break;
            case "tbsp": result = valueInTsp / 3; break;
            case "cups": result = valueInTsp / 48; break;
            case "mL": result = valueInTsp / 4.92892; break;
            case "fl oz": result = valueInTsp / 6; break;
            case "g": result = valueInTsp / 5.69; break;
        }
        displayText = result.toFixed(2) + " " + selectedUnit;
    }
}
