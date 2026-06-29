import QtQuick 2.15
import QtQuick.Controls 2.15

Column {
    spacing: config.DateTimeSpacing

    Component.onCompleted: {
        timeLabel.updateTime();
        dateLabel.updateDate();
    }

    Text {
        id: dateLabel

        function updateDate() {
            text = new Date().toLocaleDateString(Qt.locale(), config.DateFormat);
        }

        font {
            family: config.FontFamily
            pointSize: config.DateSize
            bold: config.DateIsBold === "true"
        }

        anchors { left: parent.left }

        opacity: config.DateOpacity
        renderType: Text.NativeRendering
        color: config.DateColor

        lineHeight: 1.2
    }

    Text {
        id: timeLabel

        function updateTime() {
            text = new Date().toLocaleTimeString(Qt.locale(), config.TimeFormat);
        }

        font {
            family: config.FontFamily
            pointSize: config.TimeSize
            bold: config.TimeIsBold === "true"
        }

        anchors { left: parent.left }

        opacity: config.TimeOpacity
        renderType: Text.NativeRendering
        color: config.TimeColor

        lineHeight: 1.2
    }

    Timer {
        interval: 1000
        repeat: true
        running: true
        
        onTriggered: {
            timeLabel.updateTime();
            dateLabel.updateDate();
        }
    }
}
