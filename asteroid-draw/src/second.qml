import QtQuick 2.9
import org.asteroid.controls 1.0

Application {
    id: secondApp

    property var mainApp

    // Keep the original gray background
    centerColor: "#606060"
    outerColor: "#303030"

    property real circleSize: 40
    property real minSize: 10
    property real maxSize: 200
    property color currentColor: "red"
    property var colors: [
        "#FF0000", "#FF4500", "#FFA500", "#FFD700", "#FFFF00", "#9ACD32",
        "#00FF00", "#00FA9A", "#00FFFF", "#1E90FF", "#0000FF", "#8A2BE2",
        "#FF00FF", "#EE82EE", "#FF1493", "#FF69B4", "#FF6347", "#FF8C00",
        "#CD5C5C", "#F08080", "#FA8072", "#E9967A", "#FFA07A", "#BC8F8F",
        "#B22222", "#8B0000", "#A52A2A", "#800000", "#556B2F", "#6B8E23",
        "#7CFC00", "#32CD32", "#228B22", "#008000", "#006400", "#66CDAA",
        "#5F9EA0", "#4682B4", "#6495ED", "#4169E1", "#000080", "#191970",
        "#7B68EE", "#9370DB", "#8B008B", "#9932CC", "#9400D3", "#4B0082",
        "#FFFFFF", "#F5F5F5", "#EEEEEE", "#E0E0E0", "#D3D3D3", "#C0C0C0",
        "#A9A9A9", "#808080", "#696969", "#555555", "#3D3D3D", "#2F2F2F",
        "#212121", "#121212", "#000000"
    ]
    property int colorIndex: 0

    Component.onCompleted: {
        if (mainApp) {
            currentColor = mainApp.eraserMode ? mainApp.eraserColor : mainApp.drawColor;
            circleSize = mainApp.lineWidth * 2;
        }
    }

    IconButton {
        iconName: "ios-arrow-back"
        iconColor: "white"
        anchors {
            verticalCenter: parent.verticalCenter;
            left: parent.left;
            margins: Dims.h(5);
        }
        onClicked: {
            mainApp.drawColor = currentColor;
            mainApp.lineWidth = circleSize / 2;
            mainApp.currentPage = "mainPage";
        }
    }

    Label {
        text: Math.round(circleSize) + "px • " + getColorName(currentColor)
        color: "white"
        font.pixelSize: Dims.l(8)
        anchors {
            top: parent.top;
            horizontalCenter: parent.horizontalCenter;
            margins: Dims.h(5);
        }

        function getColorName(clr) {
            const names = {
                "#FF0000": "red", "#FF4500": "orange-red", "#FFA500": "orange",
                "#FFD700": "gold", "#FFFF00": "yellow", "#9ACD32": "yellow-green",
                "#00FF00": "green", "#00FA9A": "mint", "#00FFFF": "cyan",
                "#1E90FF": "blue", "#0000FF": "blue", "#8A2BE2": "violet",
                "#FF00FF": "magenta", "#EE82EE": "pink", "#FF1493": "hot pink",
                "#FF69B4": "pink", "#FF6347": "coral", "#FF8C00": "dark orange",
                "#FFFFFF": "white", "#000000": "black"
            }
            return names[clr] || clr
        }
    }

    Rectangle {
        id: mainCircle
        width: circleSize
        height: circleSize
        radius: circleSize/2
        color: currentColor
        anchors.centerIn: parent

        MouseArea {
            anchors.fill: parent
            onClicked: {
                colorIndex = (colorIndex + 1) % colors.length;
                currentColor = colors[colorIndex];
            }
        }
    }

    Row {
        anchors {
            bottom: parent.bottom;
            horizontalCenter: parent.horizontalCenter;
            margins: Dims.h(5);
        }
        spacing: Dims.h(5);

        IconButton {
            iconName: "ios-remove"
            iconColor: "white"
            onClicked: if (circleSize > minSize) circleSize -= 5;
        }

        IconButton {
            iconName: "ios-add"
            iconColor: "white"
            onClicked: if (circleSize < maxSize) circleSize += 5;
        }
    }
}
