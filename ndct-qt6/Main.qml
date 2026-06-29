import QtQuick
import QtQuick.Controls
import QtQuick.Window

import "./components"

Rectangle {
    id: root

    height: Screen.height
    width: Screen.width

    Image {
        anchors { fill: parent }

        source: config.BgSource
        fillMode: Image.PreserveAspectCrop
        clip: true
    }

    Item {
        anchors {
            fill: parent
            margins: config.Padding
        }

        DateTimePanel {
            anchors {
                top: parent.top
                left: parent.left
            }
        }

        LoginPanel {
            anchors { fill: parent }
        }
    }
}
