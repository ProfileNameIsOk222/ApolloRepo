import QtQuick 2.9
import org.asteroid.controls 1.0

Application {
    id: app

    centerColor: "#222222"
    outerColor: "#000000"

    property string currentPage: "menuPage"

    // Menu Page
    Item {
        anchors.fill: parent
        visible: currentPage === "menuPage"

        Grid {
            anchors.centerIn: parent
            rows: 3
            columns: 3
            spacing: 10

            Repeater {
                model: [
                    { name: "Length", page: "lengthPage", color: "#f4a261", 
                      centerColor: "#b04d1c", outerColor: "#421c0a" },
                    { name: "Weight", page: "weightPage", color: "#a3d977", 
                      centerColor: "#2e8b57", outerColor: "#1a4d32" },
                    { name: "Volume", page: "volumePage", color: "#c9a0dc", 
                      centerColor: "#6a0dad", outerColor: "#3d0066" },
                    { name: "Temp", page: "tempPage", color: "#ff8a80", 
                      centerColor: "#d32f2f", outerColor: "#7b0000" },
                    { name: "Speed", page: "speedPage", color: "#fff59d", 
                      centerColor: "#ffd600", outerColor: "#c7a500" },
                    { name: "Area", page: "areaPage", color: "#90caf9", 
                      centerColor: "#1976d2", outerColor: "#0d47a1" },
                    { name: "Cook", page: "cookPage", color: "#ffb6a8", 
                      centerColor: "#fa8072", outerColor: "#c96659" },
                    { name: "Money", page: "moneyPage", color: "#e0e0e0", 
                      centerColor: "#c0c0c0", outerColor: "#808080" },
                    { name: "Time", page: "timePage", color: "#9370db", 
                      centerColor: "#4b0082", outerColor: "#2e0854" }
                ]

                delegate: Rectangle {
                    width: 80
                    height: 80
                    radius: width/2
                    color: modelData.color
                    border.color: "#000000"
                    border.width: 2

                    Label {
                        anchors.centerIn: parent
                        text: modelData.name
                        color: "#000000"
                        font.pixelSize: 14
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        maximumLineCount: 2
                        wrapMode: Text.Wrap
                        width: parent.width - 10
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            app.currentPage = modelData.page;
                            app.centerColor = modelData.centerColor;
                            app.outerColor = modelData.outerColor;
                        }
                    }
                }
            }
        }
    }

    // Length Converter Loader
    Loader {
        id: lengthLoader
        active: currentPage === "lengthPage"
        source: "tenth.qml"
        anchors.fill: parent
        onLoaded: {
            item.parentApp = Qt.binding(function() { return app });
        }
    }

    // Weight Converter Loader
    Loader {
        id: weightLoader
        active: currentPage === "weightPage"
        source: "second.qml"
        anchors.fill: parent
        onLoaded: {
            item.parentApp = Qt.binding(function() { return app });
        }
    }

    // Volume Converter Loader
    Loader {
        id: volumeLoader
        active: currentPage === "volumePage"
        source: "third.qml"
        anchors.fill: parent
        onLoaded: {
            item.parentApp = Qt.binding(function() { return app });
        }
    }

    // Temperature Converter Loader
    Loader {
        id: tempLoader
        active: currentPage === "tempPage"
        source: "fourth.qml"
        anchors.fill: parent
        onLoaded: {
            item.parentApp = Qt.binding(function() { return app });
        }
    }

    // Speed Converter Loader
    Loader {
        id: speedLoader
        active: currentPage === "speedPage"
        source: "fifth.qml"
        anchors.fill: parent
        onLoaded: {
            item.parentApp = Qt.binding(function() { return app });
        }
    }

    // Area Converter Loader
    Loader {
        id: areaLoader
        active: currentPage === "areaPage"
        source: "sixth.qml"
        anchors.fill: parent
        onLoaded: {
            item.parentApp = Qt.binding(function() { return app });
        }
    }

    // Cooking Converter Loader
    Loader {
        id: cookLoader
        active: currentPage === "cookPage"
        source: "seventh.qml"
        anchors.fill: parent
        onLoaded: {
            item.parentApp = Qt.binding(function() { return app });
        }
    }

    // Currency Converter Loader
    Loader {
        id: moneyLoader
        active: currentPage === "moneyPage"
        source: "eighth.qml"
        anchors.fill: parent
        onLoaded: {
            item.parentApp = Qt.binding(function() { return app });
        }
    }

    // Time Converter Loader
    Loader {
        id: timeLoader
        active: currentPage === "timePage"
        source: "ninth.qml"
        anchors.fill: parent
        onLoaded: {
            item.parentApp = Qt.binding(function() { return app });
        }
    }

    function showMenu() {
        currentPage = "menuPage";
        centerColor = "#222222";
        outerColor = "#000000";
    }
}
