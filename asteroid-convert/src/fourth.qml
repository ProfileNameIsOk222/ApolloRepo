import QtQuick 2.9
import org.asteroid.controls 1.0

Application {
    id: app

    centerColor: "#d32f2f"
    outerColor: "#7b0000"

    property string displayText: "0"
    property bool isConversionMode: false
    property real inputValue: 0
    property string selectedUnit: ""
    property string baseUnit: "°C"

    // Clickable header
    Rectangle {
        width: 180
        height: 40
        radius: 20
        color: "#ff8a80"
        anchors {
            top: parent.top
            topMargin: 20
            horizontalCenter: parent.horizontalCenter
        }
        border.color: "#000000"
        border.width: 2

        Label {
            anchors.centerIn: parent
            text: "Temp Converter"
            color: "#000000"
            font.pixelSize: 16
            font.bold: true
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                var newApp = Qt.createComponent("fifth.qml");
                if (newApp.status === Component.Ready) {
                    var window = newApp.createObject(app);
                    window.show();
                }
            }
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
        rows: isConversionMode ? 1 : 2
        columns: isConversionMode ? 3 : 5
        spacing: 8
        anchors {
            bottom: parent.bottom
            bottomMargin: isConversionMode ? 120 : 120
            horizontalCenter: parent.horizontalCenter
        }

        Repeater {
            model: isConversionMode 
                ? ["°C", "°F", "K"]
                : ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
            
            delegate: Rectangle {
                width: 50
                height: 50
                color: "#ff8a80"
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
            color: "#ff8a80"
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
            color: "#ff8a80"
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
            color: "#ff8a80"
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
            color: "#ff8a80"
            radius: 8
            border.color: "#000000"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    const units = ["°C", "°F", "K"];
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
        let result;
        const value = inputValue;
        
        let tempInCelsius;
        switch (baseUnit) {
            case "°C": tempInCelsius = value; break;
            case "°F": tempInCelsius = (value - 32) * 5/9; break;
            case "K": tempInCelsius = value - 273.15; break;
        }
        
        switch (selectedUnit) {
            case "°C": result = tempInCelsius; break;
            case "°F": result = (tempInCelsius * 9/5) + 32; break;
            case "K": result = tempInCelsius + 273.15; break;
        }
        
        app.displayText = result.toFixed(2) + " " + selectedUnit;
    }
}
