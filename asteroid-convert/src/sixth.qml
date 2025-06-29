import QtQuick 2.9
import org.asteroid.controls 1.0

Application {
    id: app

    centerColor: "#1976d2"
    outerColor: "#0d47a1"
    property string currentPage: "sixthPage"
    visible: currentPage === "sixthPage"

    property string displayText: "0"
    property bool isConversionMode: false
    property real inputValue: 0
    property string selectedUnit: ""
    property string baseUnit: "m²"

    // Clickable header
    Rectangle {
        width: 180
        height: 40
        radius: 20
        color: "#90caf9"
        anchors {
            top: parent.top
            topMargin: 20
            horizontalCenter: parent.horizontalCenter
        }
        border.color: "#000000"
        border.width: 2

        Label {
            anchors.centerIn: parent
            text: "Area Converter"
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
                ? ["m²", "ft²", "in²", "ha", "acres", "km²"]
                : ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
            
            delegate: Rectangle {
                width: 50
                height: 50
                color: "#90caf9"
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
                    font.pixelSize: modelData.length > 3 ? 14 : 18
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
            color: "#90caf9"
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
            color: "#90caf9"
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
            color: "#90caf9"
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
            color: "#90caf9"
            radius: 8
            border.color: "#000000"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    const units = ["m²", "ft²", "in²", "ha", "acres", "km²"];
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
        let factor = 1;
        switch (baseUnit) {
            case "ft²": factor = 1 / 10.7639; break;
            case "in²": factor = 1 / 1550; break;
            case "ha": factor = 1 / 0.0001; break;
            case "acres": factor = 1 / 0.000247105; break;
            case "km²": factor = 1 / 0.000001; break;
        }
        switch (selectedUnit) {
            case "m²": factor *= 1; break;
            case "ft²": factor *= 10.7639; break;
            case "in²": factor *= 1550; break;
            case "ha": factor *= 0.0001; break;
            case "acres": factor *= 0.000247105; break;
            case "km²": factor *= 0.000001; break;
        }
        displayText = (inputValue * factor).toFixed(4) + " " + selectedUnit;
    }
}
