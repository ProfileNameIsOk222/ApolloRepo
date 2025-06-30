import QtQuick 2.9
import org.asteroid.controls 1.0

Application {
    id: app

    centerColor: "#4b0082"
    outerColor: "#2e0854"
    property string currentPage: "ninthPage"
    visible: currentPage === "ninthPage"

    property string displayText: "0"
    property bool isConversionMode: false
    property real inputValue: 0
    property string selectedUnit: ""
    property string baseUnit: "s"

    // Clickable header
    Rectangle {
        width: 180
        height: 40
        radius: 20
        color: "#9370db"
        anchors {
            top: parent.top
            topMargin: 20
            horizontalCenter: parent.horizontalCenter
        }
        border.color: "#000000"
        border.width: 2

        Label {
            anchors.centerIn: parent
            text: "Time Converter"
            color: "#000000"
            font.pixelSize: 16
            font.bold: true
        }

        MouseArea {
            anchors.fill: parent
            onClicked: currentPage = "menuPage"
        }
    }

    Label {
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: grid.top
            bottomMargin: 20
        }
        text: app.displayText
        color: "#FFFFFF"
        font.pixelSize: 50
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

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
                ? ["s", "min", "h", "d", "wk", "mo"]
                : ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
            
            delegate: Rectangle {
                width: 50
                height: 50
                color: "#9370db"
                radius: 8
                border.color: "#000000"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (isConversionMode) {
                            app.selectedUnit = modelData;
                            app.convertValue();
                        } else {
                            if (app.displayText === "0" && modelData !== ".") {
                                app.displayText = modelData;
                            } else {
                                app.displayText += modelData;
                            }
                            app.inputValue = parseFloat(app.displayText);
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
            color: "#9370db"
            radius: 8
            border.color: "#000000"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (isConversionMode) {
                        isConversionMode = false;
                        app.displayText = String(app.inputValue);
                    } else if (!app.displayText.includes(".")) {
                        app.displayText += ".";
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

        Rectangle {
            width: 60
            height: 40
            color: "#9370db"
            radius: 8
            border.color: "#000000"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    app.displayText = "0";
                    app.inputValue = 0;
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

        Rectangle {
            width: 60
            height: 40
            color: "#9370db"
            radius: 8
            border.color: "#000000"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    isConversionMode = true;
                    app.inputValue = parseFloat(app.displayText);
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

        Rectangle {
            width: 90
            height: 40
            color: "#9370db"
            radius: 8
            border.color: "#000000"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    const units = ["s", "min", "h", "d", "wk", "mo"];
                    const currentIndex = units.indexOf(baseUnit);
                    app.baseUnit = units[(currentIndex + 1) % units.length];
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
        // First convert input to seconds (the common base unit)
        let valueInSeconds;
        switch (baseUnit) {
            case "s": valueInSeconds = inputValue; break;
            case "min": valueInSeconds = inputValue * 60; break;
            case "h": valueInSeconds = inputValue * 3600; break;
            case "d": valueInSeconds = inputValue * 86400; break;
            case "wk": valueInSeconds = inputValue * 604800; break;
            case "mo": valueInSeconds = inputValue * 2.628e6; break; // Approximate: 1 month = 30.44 days
        }
        
        // Then convert from seconds to selected unit
        let result;
        switch (selectedUnit) {
            case "s": result = valueInSeconds; break;
            case "min": result = valueInSeconds / 60; break;
            case "h": result = valueInSeconds / 3600; break;
            case "d": result = valueInSeconds / 86400; break;
            case "wk": result = valueInSeconds / 604800; break;
            case "mo": result = valueInSeconds / 2.628e6; break;
        }
        app.displayText = result.toFixed(2) + " " + selectedUnit;
    }
}
