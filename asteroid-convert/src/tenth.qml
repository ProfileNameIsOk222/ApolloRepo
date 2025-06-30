import QtQuick 2.9
import org.asteroid.controls 1.0

Item {
    property var parentApp
    anchors.fill: parent

    property string displayText: "0"
    property bool isConversionMode: false
    property real inputValue: 0
    property string selectedUnit: ""
    property string baseUnit: "in"

    // Header with back button
    Rectangle {
        width: 180
        height: 40
        radius: 20
        color: "#f4a261"
        anchors {
            top: parent.top
            topMargin: 20
            horizontalCenter: parent.horizontalCenter
        }
        border.color: "#000000"
        border.width: 2

        Label {
            anchors.centerIn: parent
            text: "Length Converter"
            color: "#000000"
            font.pixelSize: 16
            font.bold: true
        }

        MouseArea {
            anchors.fill: parent
            onClicked: parentApp.showMenu()
        }
    }

    // Large display for entered number
    Label {
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: grid.top
            bottomMargin: 20
        }
        text: displayText
        color: "#FFFFFF"
        font.pixelSize: 50
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    // Button grid or conversion options
    Grid {
        id: grid
        rows: isConversionMode ? 1 : 2
        columns: isConversionMode ? 6 : 5
        spacing: 8
        anchors {
            bottom: parent.bottom
            bottomMargin: isConversionMode ? 120 : 120
            horizontalCenter: parent.horizontalCenter
        }

        Repeater {
            model: isConversionMode 
                ? ["cm", "mm", "ft", "yd", "m", "in"] 
                : ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
            
            delegate: Rectangle {
                width: 50
                height: 50
                color: "#f4a261"
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
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }

    // Additional buttons for Bottom Row
    Row {
        spacing: 10
        anchors {
            bottom: parent.bottom
            bottomMargin: isConversionMode ? 60 : 60
            horizontalCenter: parent.horizontalCenter
        }

        // Decimal Button / Back Button
        Rectangle {
            width: 60
            height: 40
            color: "#f4a261"
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
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        // Clear Button
        Rectangle {
            width: 60
            height: 40
            color: "#f4a261"
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
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        // Next Step Button (>)
        Rectangle {
            width: 60
            height: 40
            color: "#f4a261"
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
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        // Change Base Unit Button
        Rectangle {
            width: 90
            height: 40
            color: "#f4a261"
            radius: 8
            border.color: "#000000"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    const units = ["in", "cm", "mm", "ft", "yd", "m"];
                    const currentIndex = units.indexOf(baseUnit);
                    baseUnit = units[(currentIndex + 1) % units.length];
                }
            }

            Label {
                anchors.centerIn: parent
                text: "Base: " + baseUnit
                color: "#000000"
                font.pixelSize: 14
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    function convertValue() {
        let factor = 1;
        let unitSuffix = selectedUnit;

        switch (baseUnit) {
            case "cm": factor = 1 / 2.54; break;
            case "mm": factor = 1 / 25.4; break;
            case "ft": factor = 1 / 0.0833333; break;
            case "yd": factor = 1 / 0.0277778; break;
            case "m": factor = 1 / 0.0254; break;
        }

        switch (selectedUnit) {
            case "cm": factor *= 2.54; break;
            case "mm": factor *= 25.4; break;
            case "ft": factor *= 0.0833333; break;
            case "yd": factor *= 0.0277778; break;
            case "m": factor *= 0.0254; break;
            case "in": factor *= 1; break;
        }

        const convertedValue = inputValue * factor;
        displayText = convertedValue.toFixed(4) + " " + unitSuffix;
    }
}
