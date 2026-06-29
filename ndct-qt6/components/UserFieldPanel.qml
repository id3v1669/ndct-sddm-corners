import QtQuick
import QtQuick.Controls

TextField {
    id: usernameField

    height: inputHeight
    width: inputWidth
    selectByMouse: true

    font {
        family: config.FontFamily
        pointSize: config.FontSize
        bold: true
    }

    text: userModel.lastUser
    placeholderText: config.UserPlaceholderText
    horizontalAlignment: Text.AlignHCenter

    color: config.InputTextColor
    selectionColor: config.InputTextColor
    renderType: Text.NativeRendering
 
    states: [
        State {
            name: "focused"
            when: usernameField.activeFocus

            PropertyChanges {
                userFieldBackground.color: Qt.darker(config.InputColor, 1.2)
                userFieldBackground.border.width: config.InputBorderWidth
            }
        },
        State {
            name: "hovered"
            when: usernameField.hovered

            PropertyChanges {
                userFieldBackground.color: Qt.darker(config.InputColor, 1.2)
            }
        }
    ]

    background: Rectangle {
        id: userFieldBackground

        color: config.InputColor
        border.color: config.InputBorderColor
        border.width: 0
        radius: config.Radius
    }

    transitions: Transition {
        PropertyAnimation {
            properties: "color, border.width"
            duration: 150
        }
    }
}
