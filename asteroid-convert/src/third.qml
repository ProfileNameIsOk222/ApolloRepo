import QtQuick 2.9
import org.asteroid.controls 1.0

Application {
    id: app

    centerColor: "#6a0dad"
    outerColor: "#3d0066"

    property string displayText: "0"
    property bool isConversionMode: false
    property real inputValue: 0
    property string selectedUnit: ""
    property string baseUnit: "L"

    // Clickable header
    Rectangle {
        width: 180
        height: 40
        radius: 20
        color: "#c9a0dc"
        anchors {
            top: parent.top
            topMargin: 20
            horizontalCenter: parent.horizontalCenter
        }
        border.color: "#000000"
        border.width: 2

        Label {
            anchors.centerIn: parent
            text: "Volume Converter"
            color: "#000000"
            font.pixelSize: 16
            font.bold: true
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                var newApp = Qt.createComponent("fourth.qml");
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
                ? ["L", "mL", "gal", "fl oz", "pt", "qt"]
                : ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
            
            delegate: Rectangle {
                width: 50
                height: 50
                color: "#c9a0dc"
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
            color: "#c9a0dc"
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
            color: "#c9a0dc"
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
            color: "#c9a0dc"
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
            color: "#c9a0dc"
            radius: 8
            border.color: "#000000"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    const units = ["L", "mL", "gal", "fl oz", "pt", "qt"];
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
            case "mL": factor = 1 / 1000; break;
            case "gal": factor = 1 / 0.264172; break;
            case "fl oz": factor = 1 / 33.814; break;
            case "pt": factor = 1 / 2.11338; break;
            case "qt": factor = 1 / 1.05669; break;
        }

        switch (selectedUnit) {
            case "L": factor *= 1; break;
            case "mL": factor *= 1000; break;
            case "gal": factor *= 0.264172; break;
            case "fl oz": factor *= 33.814; break;
            case "pt": factor *= 2.11338; break;
            case "qt": factor *= 1.05669; break;
        }

        const convertedValue = inputValue * factor;
        app.displayText = convertedValue.toFixed(4) + " " + unitSuffix;
    }
}
