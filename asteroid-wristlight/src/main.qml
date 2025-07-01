import QtQuick 2.9
import org.asteroid.controls 1.0
import org.asteroid.utils 1.0
import org.nemomobile.systemsettings 1.0
import Nemo.KeepAlive 1.1

Application {
    centerColor: "#391557"
    outerColor: "#9218f5"
    property int startBrightness: -1
    
    // Color selection
    property var colors: [
        "#ffffff",  // white
        "#ff0000",  // red
        "#ff8000",  // orange
        "#ffff00",  // yellow
        "#00ff00",  // green
        "#0000ff",  // blue
        "#8000ff",  // purple
        "#ff00ff"   // pink
    ]
    property string currentColor: colors[0]
    property int colorIndex: 0
    property bool sosActive: false

    DisplaySettings {
        id: displaySettings
        onBrightnessChanged: {
            if (startBrightness != -1) return;
            startBrightness = brightness;
            displaySettings.brightness = displaySettings.maximumBrightness;
        }
    }

    // SOS Timer
    Timer {
        id: sosTimer
        interval: 200
        repeat: true
        running: false
        onTriggered: {
            flashCircle.color = flashCircle.color == "#ff0000" ? "#000000" : "#ff0000";
        }
    }

    Rectangle {
        id: flashCircle
        property bool flashOn: false // Start with light off

        anchors.centerIn: parent
        anchors.verticalCenterOffset: DeviceSpecs.flatTireHeight/2
        color: flashOn ? (sosActive ? "#ff0000" : currentColor) : "#000000"
        width: flashOn ? Dims.w(100) : Dims.w(45)
        height: flashOn ? Dims.h(100) : Dims.h(45)
        radius: DeviceSpecs.hasRoundScreen ? width : flashOn ? 0 : width

        Icon {
            id: bulbIcon
            anchors.centerIn: parent
            width: parent.width * 0.7
            height: width
            color: parent.flashOn ? Qt.darker(parent.color, 1.5) : "#FFF"
            name: sosActive ? "ios-alert" : (parent.flashOn ? "ios-sunny-outline" : "ios-sunny-outline")
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (sosActive) {
                    sosActive = false;
                    sosTimer.stop();
                }
                flashCircle.flashOn = !flashCircle.flashOn;
                displaySettings.brightness = flashCircle.flashOn ? displaySettings.maximumBrightness : startBrightness;
                // Ensure color updates when turning on
                if (flashCircle.flashOn) {
                    flashCircle.color = sosActive ? "#ff0000" : currentColor;
                }
            }
        }

        Behavior on width { NumberAnimation { duration: 100 } }
        Behavior on height { NumberAnimation { duration: 100 } }
        Behavior on radius { NumberAnimation { duration: 100 } }
        Behavior on color { ColorAnimation { duration: 150 } }
    }

    // Color button
    Rectangle {
        id: colorButton
        width: Dims.w(20)
        height: Dims.h(20)
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: DeviceSpecs.flatTireHeight/2
            leftMargin: Dims.w(5)
        }
        radius: width/2
        color: currentColor
        border.width: 2
        border.color: "#ffffff"
        opacity: (flashCircle.flashOn || sosActive) ? 0 : 1
        visible: opacity > 0
        enabled: visible

        Behavior on opacity { NumberAnimation { duration: 150 } }

        Icon {
            anchors.centerIn: parent
            width: parent.width * 0.7
            height: width
            name: "ios-color-palette"
            color: "#000000"
            opacity: 0.7
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                colorIndex = (colorIndex + 1) % colors.length;
                currentColor = colors[colorIndex];
                // Update light immediately if on (and not in SOS mode)
                if (flashCircle.flashOn && !sosActive) {
                    flashCircle.color = currentColor;
                }
            }
        }
    }

    // SOS button
    Rectangle {
        id: sosButton
        width: Dims.w(20)
        height: Dims.h(20)
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: DeviceSpecs.flatTireHeight/2
            rightMargin: Dims.w(5)
        }
        radius: width/2
        color: sosActive ? "#ff0000" : "#400000"
        border.width: 2
        border.color: "#ffffff"
        opacity: flashCircle.flashOn ? 0 : 1
        visible: opacity > 0
        enabled: visible

        Behavior on opacity { NumberAnimation { duration: 150 } }
        Behavior on color { ColorAnimation { duration: 300 } }

        Icon {
            anchors.centerIn: parent
            width: parent.width * 0.7
            height: width
            name: "ios-alert"
            color: "#ffffff"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (!sosActive) {
                    sosActive = true;
                    flashCircle.flashOn = true;
                    flashCircle.color = "#ff0000";
                    displaySettings.brightness = displaySettings.maximumBrightness;
                    sosTimer.start();
                }
            }
        }
    }

    Component.onCompleted: DisplayBlanking.preventBlanking = true;
    Component.onDestruction: {
        displaySettings.brightness = startBrightness;
        sosTimer.stop();
    }
}
