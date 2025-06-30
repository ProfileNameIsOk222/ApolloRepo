import QtQuick 2.9
import org.asteroid.controls 1.0

Application {
    id: app

    centerColor: "#2e8b57"
    outerColor: "#1a4d32"
    property string currentPage: "secondPage"
    visible: currentPage === "secondPage"

    property string displayText: "0"
    property bool isConversionMode: false
    property real inputValue: 0
    property string selectedUnit: ""
    property string baseUnit: "kg"

    // Clickable header
    Rectangle {
        width: 180
        height: 40
        radius: 20
        color: "#a3d977"
        anchors {
            top: parent.top
            topMargin: 20
            horizontalCenter: parent.horizontalCenter
        }
        border.color: "#000000"
        border.width: 2

        Label {
            anchors.centerIn: parent
            text: "Weight Converter"
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
        text: app.displayText
        color: "#FFFFFF"
        font.pixelSize: 50
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    // Button grid
    Grid {
        id: grid
        rows: isConversionMode ? 1 : 2
        columns: isConversionMode ? 4 : 5
        spacing: 8
        anchors {
            bottom: parent.bottom
            bottomMargin: isConversionMode ? 120 : 120
            horizontalCenter: parent.horizontalCenter
        }

        Repeater {
            model: isConversionMode 
                ? ["kg", "g", "lb", "oz"]
                : ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
            
            delegate: Rectangle {
                width: 50
                height: 50
                color: "#a3d977"
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
            color: "#a3d977"
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
            color: "#a3d977"
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
            color: "#a3d977"
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
            color: "#a3d977"
            radius: 8
            border.color: "#000000"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    const units = ["kg", "g", "lb", "oz"];
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
        let factor = 1;
        let unitSuffix = selectedUnit;

        switch (baseUnit) {
            case "g": factor = 1 / 1000; break;
            case "lb": factor = 1 / 2.20462; break;
            case "oz": factor = 1 / 35.274; break;
        }

        switch (selectedUnit) {
            case "kg": factor *= 1; break;
            case "g": factor *= 1000; break;
            case "lb": factor *= 2.20462; break;
            case "oz": factor *= 35.274; break;
        }

        const convertedValue = inputValue * factor;
        app.displayText = convertedValue.toFixed(4) + " " + unitSuffix;
    }
}
