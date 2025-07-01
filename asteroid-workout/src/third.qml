import QtQuick 2.9
import org.asteroid.controls 1.0

Item {
    id: summaryPage

    property var parentPage
    property var workoutData

    Rectangle {
        anchors.fill: parent
        color: "#111111"

        Column {
            anchors.centerIn: parent
            width: parent.width * 0.9
            spacing: Dims.h(4)

            // Header - Centered
            Label {
                text: "WORKOUT COMPLETE"
                font.pixelSize: Dims.h(6)
                color: "#43A047"
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
            }

            // Stats Grid - Centered
            Grid {
                columns: 2
                spacing: Dims.w(5)
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter

                // Type
                Label {
                    text: "Type:"
                    font.pixelSize: Dims.h(4)
                    color: "#AAAAAA"
                    width: parent.width * 0.4
                    horizontalAlignment: Text.AlignRight
                }
                Label {
                    text: workoutData.type
                    font.pixelSize: Dims.h(4)
                    color: "white"
                    width: parent.width * 0.6
                    horizontalAlignment: Text.AlignLeft
                }

                // Duration
                Label {
                    text: "Time:"
                    font.pixelSize: Dims.h(4)
                    color: "#AAAAAA"
                    width: parent.width * 0.4
                    horizontalAlignment: Text.AlignRight
                }
                Label {
                    text: formatTime(workoutData.duration)
                    font.pixelSize: Dims.h(4)
                    color: "white"
                    width: parent.width * 0.6
                    horizontalAlignment: Text.AlignLeft
                }

                // Calories
                Label {
                    text: "Calories:"
                    font.pixelSize: Dims.h(4)
                    color: "#AAAAAA"
                    width: parent.width * 0.4
                    horizontalAlignment: Text.AlignRight
                }
                Label {
                    text: workoutData.calories + " kcal"
                    font.pixelSize: Dims.h(4)
                    color: "white"
                    width: parent.width * 0.6
                    horizontalAlignment: Text.AlignLeft
                }

                // Orange Zone
                Label {
                    text: "Orange Zone:"
                    font.pixelSize: Dims.h(4)
                    color: "#AAAAAA"
                    width: parent.width * 0.4
                    horizontalAlignment: Text.AlignRight
                }
                Label {
                    text: formatTime(workoutData.orangeZoneTime)
                    font.pixelSize: Dims.h(4)
                    color: "white"
                    width: parent.width * 0.6
                    horizontalAlignment: Text.AlignLeft
                }
            }

            // Done Button - Centered
            Rectangle {
                id: doneButton
                width: Dims.w(30)
                height: Dims.h(8)
                radius: height/2
                color: "#43A047"
                anchors.horizontalCenter: parent.horizontalCenter

                Label {
                    text: "DONE"
                    font.pixelSize: Dims.h(4)
                    font.bold: true
                    color: "white"
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        parentPage.resetWorkout();
                        parentPage.currentPage = "mainPage";
                    }
                }
            }
        }
    }

    function formatTime(seconds) {
        var mins = Math.floor(seconds / 60);
        var secs = seconds % 60;
        return mins.toString().padStart(2, '0') + ":" + secs.toString().padStart(2, '0');
    }
}
