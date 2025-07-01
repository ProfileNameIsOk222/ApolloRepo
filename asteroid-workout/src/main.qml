import QtQuick 2.9
import QtSensors 5.11
import org.asteroid.controls 1.0
import org.asteroid.utils 1.0
import Nemo.KeepAlive 1.1
import Qt.labs.settings 1.0
import Nemo.Ngf 1.0  // Required for vibration

Application {
    id: app

    // Vibration Feedback
    NonGraphicalFeedback {
        id: feedback
        event: "press"
    }

    function vibrate() {
        feedback.play()
    }

    // Persistent settings
    Settings {
        id: appSettings
        property int age: 30
        property int weight: 150
        property string workoutType: "General"
        property bool vibrationEnabled: true
    }

    // Workout stats
    property int timeInOrangeZone: 0
    property string previousColorZone: "grey"
    
    Timer {
        interval: 1000
        running: workoutActive && currentColorZone === "orange"
        repeat: true
        onTriggered: timeInOrangeZone++
    }

    // Calculate MaxHR
    property int maxHR: {
        switch(appSettings.workoutType) {
            case "Running": return 208 - (0.7 * appSettings.age);
            case "Cycling": return 220 - appSettings.age;
            case "HIIT": return 210 - (0.65 * appSettings.age);
            default: return 220 - appSettings.age;
        }
    }

    // Target zones
    property var zoneThresholds: {
        switch(appSettings.workoutType) {
            case "Running": return [0.50, 0.60, 0.70, 0.80, 0.90];
            case "Cycling": return [0.55, 0.65, 0.75, 0.85, 0.95];
            case "HIIT": return [0.60, 0.70, 0.80, 0.90, 1.00];
            default: return [0.50, 0.60, 0.70, 0.80, 0.90];
        }
    }

    // Current zone for background colors
    property string currentColorZone: {
        if (bpm < maxHR * zoneThresholds[0]) return "grey";
        else if (bpm < maxHR * zoneThresholds[1]) return "blue";
        else if (bpm < maxHR * zoneThresholds[2]) return "green";
        else if (bpm < maxHR * zoneThresholds[3]) return "orange";
        else return "red";
    }

    // Vibrate on zone change
    onCurrentColorZoneChanged: {
        if (workoutActive && appSettings.vibrationEnabled && currentColorZone !== previousColorZone) {
            vibrate();
        }
        previousColorZone = currentColorZone;
    }

    // Page management
    property string currentPage: "mainPage"

    // Dynamic background colors
    centerColor: getCenterColor(currentColorZone)
    outerColor: getOuterColor(currentColorZone)
    
    Behavior on centerColor {
        ColorAnimation { duration: 1000; easing.type: Easing.InOutQuad }
    }
    Behavior on outerColor {
        ColorAnimation { duration: 1000; easing.type: Easing.InOutQuad }
    }

    // Heart rate data
    property int bpm: 0
    property int lastBpm: 0

    // Workout timer
    property bool workoutActive: false
    property int workoutSeconds: 0
    property string formattedTime: "00:00"

    // Calorie estimation
    property real caloriesBurned: (bpm * workoutSeconds * 0.00067).toFixed(1)

    // Reset workout stats
    function resetWorkout() {
        workoutActive = false;
        workoutSeconds = 0;
        timeInOrangeZone = 0;
        formattedTime = "00:00";
        caloriesBurned = 0;
        bpm = 0;
        previousColorZone = "grey";
    }

    // Heart rate sensor
    HrmSensor {
        active: true
        onReadingChanged: {
            lastBpm = bpm;
            bpm = reading.bpm;
        }
    }

    // Timer to update workout duration
    Timer {
        id: workoutTimer
        interval: 1000
        running: workoutActive
        repeat: true
        onTriggered: {
            workoutSeconds++;
            formattedTime = 
                Math.floor(workoutSeconds / 60).toString().padStart(2, '0') + ":" + 
                (workoutSeconds % 60).toString().padStart(2, '0');
        }
    }

    // Color logic
    function getCenterColor(zone) {
        switch(zone) {
            case "blue":   return "#1E88E5";
            case "green":  return "#43A047";
            case "orange": return "#FB8C00";
            case "red":    return "#E53935";
            default:      return "#555555";
        }
    }
    function getOuterColor(zone) {
        switch(zone) {
            case "blue":   return "#0D47A1";
            case "green":  return "#1B5E20";
            case "orange": return "#E65100";
            case "red":    return "#B71C1C";
            default:      return "#111111";
        }
    }

    // Main Page
    Item {
        anchors.fill: parent
        visible: currentPage === "mainPage"

        // Control buttons row
        Row {
            id: controlButtons
            anchors {
                top: parent.top
                topMargin: Dims.h(10)
                horizontalCenter: parent.horizontalCenter
            }
            spacing: Dims.w(8)

            // Play/Pause
            IconButton {
                width: Dims.w(18)
                height: Dims.h(18)
                iconName: workoutActive ? "ios-pause" : "ios-play"
                onClicked: workoutActive = !workoutActive
            }

            // Settings
            IconButton {
                width: Dims.w(18)
                height: Dims.h(18)
                iconName: "ios-settings"
                onClicked: currentPage = "secondPage"
            }

            // Finish Workout
            IconButton {
                width: Dims.w(18)
                height: Dims.h(18)
                iconName: "ios-flag"
                onClicked: currentPage = "thirdPage"
            }
        }

        // Heart rate display
        Label {
            anchors.centerIn: parent
            font.pixelSize: Dims.h(40)
            text: bpm > 0 ? bpm : "---"
            color: "white"
        }

        // Time and kcal
        Row {
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: Dims.h(10)
            }
            spacing: Dims.w(10)

            Label {
                font.pixelSize: Dims.h(6)
                text: formattedTime
                color: "white"
            }

            Label {
                font.pixelSize: Dims.h(6)
                text: caloriesBurned + " kcal"
                color: "white"
            }
        }
    }

    // Settings Page Loader
    Loader {
        id: settingsLoader
        active: currentPage === "secondPage"
        source: "second.qml"
        anchors.fill: parent
        
        onLoaded: {
            item.parentPage = Qt.binding(function() { return app })
            item.appSettings = Qt.binding(function() { return appSettings })
        }
    }

    // Summary Page Loader
    Loader {
        id: summaryLoader
        active: currentPage === "thirdPage"
        source: "third.qml"
        anchors.fill: parent
        
        onLoaded: {
            item.parentPage = Qt.binding(function() { return app })
            item.workoutData = Qt.binding(function() { return {
                type: appSettings.workoutType,
                duration: app.workoutSeconds,
                calories: app.caloriesBurned,
                orangeZoneTime: app.timeInOrangeZone
            }})
        }
    }

    Component.onCompleted: DisplayBlanking.preventBlanking = true
    Component.onDestruction: DisplayBlanking.preventBlanking = false
}
