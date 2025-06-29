import QtQuick 2.9
import org.asteroid.controls 1.0

Application {
    id: mainApp

    // Solid white background
    centerColor: "white"
    outerColor: "white"

    property color drawColor: "black"
    property color eraserColor: "white" // Matches background
    property real lineWidth: 20
    property string currentPage: "mainPage"
    property bool eraserMode: false

    onCurrentPageChanged: {
        if (currentPage === "mainPage") {
            centerColor = "white";
            outerColor = "white";
            eraserColor = "white"; // Update eraser color to match background
        }
    }

    Loader {
        id: pageLoader
        anchors.fill: parent
        source: currentPage === "mainPage" ? "" : "second.qml"
        onLoaded: {
            if (item) {
                item.mainApp = mainApp;
                item.circleSize = lineWidth * 2;
                item.currentColor = eraserMode ? eraserColor : drawColor;
                centerColor = "#606060";
                outerColor = "#303030";
            }
        }
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        visible: currentPage === "mainPage"
        property var lastX: 0
        property var lastY: 0

        onPaint: {
            var ctx = getContext("2d");
            ctx.lineWidth = lineWidth;
            ctx.strokeStyle = eraserMode ? eraserColor : drawColor;
            ctx.lineCap = "round";
            ctx.lineJoin = "round";
            ctx.beginPath();
            ctx.moveTo(lastX, lastY);
            ctx.lineTo(lastX2, lastY2);
            ctx.stroke();
            lastX = lastX2;
            lastY = lastY2;
        }

        MouseArea {
            anchors.fill: parent
            onPressed: {
                canvas.lastX = mouseX;
                canvas.lastY = mouseY;
            }
            onPositionChanged: {
                if (mouseX >= 0 && mouseY >= 0 && mouseX <= width && mouseY <= height) {
                    var ctx = canvas.getContext("2d");
                    ctx.lineWidth = lineWidth;
                    ctx.strokeStyle = eraserMode ? eraserColor : drawColor;
                    ctx.lineCap = "round";
                    ctx.lineJoin = "round";
                    ctx.beginPath();
                    ctx.moveTo(canvas.lastX, canvas.lastY);
                    ctx.lineTo(mouseX, mouseY);
                    ctx.stroke();
                    canvas.lastX = mouseX;
                    canvas.lastY = mouseY;
                    canvas.requestPaint();
                }
            }
        }
    }

    Row {
        anchors {
            bottom: parent.bottom;
            horizontalCenter: parent.horizontalCenter;
            margins: Dims.h(5);
        }
        spacing: Dims.h(10);
        visible: currentPage === "mainPage"

        // Eraser toggle button
        Rectangle {
            width: Dims.h(15)
            height: Dims.h(15)
            radius: width/2
            color: eraserMode ? "#dddddd" : "transparent"
            border.color: "black"
            border.width: 1

            Label {
                text: "E"
                color: "black"
                anchors.centerIn: parent
                font.pixelSize: Dims.l(8)
                font.bold: true
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    eraserMode = !eraserMode;
                    eraserColor = "white"; // Set to solid white background
                }
            }
        }

        // Brush settings button
        IconButton {
            iconName: "ios-brush-outline"
            iconColor: "black"
            onClicked: currentPage = "secondPage"
        }
    }
}
