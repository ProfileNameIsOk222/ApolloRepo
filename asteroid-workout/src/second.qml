import QtQuick 2.9
import org.asteroid.controls 1.0

Application {
    id: secondApp

    // Reference to main page for navigation back
    property var parentPage

    // Dark gray background colors
    centerColor: "#9e9e9e"
    outerColor: "#212121"

    // Current values
    property int currentHour: 0
    property string currentContinent: "NAmerica"

    // Continent options (abbreviated)
    property var continents: ["NAmerica", "SAmerica", "Africa", "Europe", "Asia", "Oceania"]

    Column {
        anchors.centerIn: parent
        spacing: Dims.l(5)
        width: parent.width * 0.9

        // Back button - returns to main page
        IconButton {
            iconName: "ios-arrow-round-back"
            onClicked: parentPage.currentPage = "mainPage"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // Hour adjustment
        Row {
            width: parent.width
            spacing: Dims.l(5)
            anchors.horizontalCenter: parent.horizontalCenter

            IconButton {
                width: Dims.l(10)
                height: Dims.l(10)
                iconName: "ios-add"
                onClicked: currentHour = (currentHour + 1) % 24
            }

            Label {
                width: Dims.l(30)
                font.pixelSize: Dims.l(12)
                horizontalAlignment: Text.AlignHCenter
                text: currentHour
            }

            IconButton {
                width: Dims.l(10)
                height: Dims.l(10)
                iconName: "ios-remove"
                onClicked: currentHour = (currentHour - 1 + 24) % 24
            }
        }

        // Continent selection
        Row {
            width: parent.width
            spacing: Dims.l(5)
            anchors.horizontalCenter: parent.horizontalCenter

            IconButton {
                width: Dims.l(10)
                height: Dims.l(10)
                iconName: "ios-arrow-back"
                onClicked: {
                    var index = continents.indexOf(currentContinent);
                    currentContinent = continents[(index - 1 + continents.length) % continents.length];
                }
            }

            Label {
                width: Dims.l(30)
                font.pixelSize: Dims.l(8)
                horizontalAlignment: Text.AlignHCenter
                text: currentContinent
            }

            IconButton {
                width: Dims.l(10)
                height: Dims.l(10)
                iconName: "ios-arrow-forward"
                onClicked: {
                    var index = continents.indexOf(currentContinent);
                    currentContinent = continents[(index + 1) % continents.length];
                }
            }
        }
    }
}
