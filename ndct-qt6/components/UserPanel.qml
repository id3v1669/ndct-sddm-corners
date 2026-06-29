import QtQml.Models
import QtQuick
import QtQuick.Controls
import QtQuick.Effects

Column {
    property var username: usernameField.text

    spacing: 30

    Component.onCompleted: {
        if (userPicture.enabled) {
            userPicture.source = userWrapper.items.get(userList.currentIndex).model.icon;
        }
    }

    DelegateModel {
        id: userWrapper

        model: userModel

        delegate: ItemDelegate {
            id: userEntry

            enabled: config.UserPictureEnabled === "true"
            visible: config.UserPictureEnabled === "true"

            height: inputHeight
            width: parent.width
            highlighted: userList.currentIndex === index

            states: [
                State {
                    name: "hovered"
                    when: userEntry.hovered

                    PropertyChanges {
                        userEntryBg.color: highlighted ? Qt.darker(config.PopupActiveColor, 1.2) : Qt.darker(config.PopupColor, 1.2)
                    }
                }
            ]

            MouseArea {
                anchors { fill: parent }

                onClicked: {
                    userList.currentIndex = index;
                    usernameField.text = userWrapper.items.get(index).model.name;
                    userPicture.source = userWrapper.items.get(index).model.icon;
                    userPopup.close();
                }
            }

            contentItem: Text {
                font {
                    family: config.FontFamily
                    pointSize: config.FontSize
                    bold: true
                }

                text: name
                renderType: Text.NativeRendering
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: highlighted ? config.PopupActiveTextColor : config.PopupActiveColor
            }

            background: Rectangle {
                id: userEntryBg

                color: highlighted ? config.PopupActiveColor : config.PopupColor
                radius: config.Radius
            }

            transitions: Transition {
                PropertyAnimation {
                    property: "color"
                    duration: 150
                }
            }
        }
    }

    Popup {
        id: userPopup
        
        enabled: config.UserPictureEnabled === "true"

        width: inputWidth
        padding: 15

        background: Rectangle {
            radius: config.Radius * 1.8
            color: config.PopupColor
        }

        contentItem: ListView {
            id: userList

            implicitHeight: contentHeight
            spacing: 8
            model: userWrapper
            currentIndex: userModel.lastIndex
            clip: true
        }

        enter: Transition {
            ParallelAnimation {
                NumberAnimation {
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 400
                    easing.type: Easing.OutExpo
                }

                NumberAnimation {
                    property: "y"
                    from: (inputWidth / 3) - userPopup.padding - (inputHeight * userList.count * 0.5) - (userList.spacing * (userList.count - 1) * 0.5) + (inputWidth * 0.1)
                    to: (inputWidth / 3) - userPopup.padding - (inputHeight * userList.count * 0.5) - (userList.spacing * (userList.count - 1) * 0.5)
                    duration: 500
                    easing.type: Easing.OutExpo
                }
            }
        }

        exit: Transition {
            NumberAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 300
                easing.type: Easing.OutExpo
            }
        }
    }

    Item {
        width: inputWidth
        implicitHeight: pictureBorder.height

        Rectangle {
            id: pictureBorder

            enabled: config.UserPictureEnabled === "true"
            visible: config.UserPictureEnabled === "true"

            anchors.centerIn: userPicture
            height: inputWidth / 1.5 + (border.width * 2)
            width: inputWidth / 1.5 + (border.width * 2)
            radius: height / 2
            border.width: config.UserBorderWidth
            border.color: config.UserBorderColor
            color: config.UserColor
            states: [
                State {
                    name: "pressed"

                    PropertyChanges {
                        pictureBorder.border.color: Qt.darker(config.UserBorderColor, 1.2)
                        pictureBorder.color: Qt.darker(config.UserColor, 1.2)
                    }
                },
                State {
                    name: "hovered"

                    PropertyChanges {
                        pictureBorder.border.color: Qt.darker(config.UserBorderColor, 1.4)
                        pictureBorder.color: Qt.darker(config.UserColor, 1.4)
                    }
                },
                State {
                    name: "unhovered"

                    PropertyChanges {
                        pictureBorder.border.color: config.UserBorderColor
                        pictureBorder.color: config.UserColor
                    }
                }
            ]

            MouseArea {
                id: roundMouseArea

                anchors.fill: parent
                hoverEnabled: true
                onClicked: userPopup.open();

                onHoveredChanged: {
                    if (containsMouse)
                        pictureBorder.state = "hovered";
                    else
                        pictureBorder.state = "unhovered";
                }

                onPressedChanged: {
                    if (containsPress)
                        pictureBorder.state = "pressed";
                    else if (containsMouse)
                        pictureBorder.state = "hovered";
                    else
                        pictureBorder.state = "unhovered";
                }
            }

            transitions: Transition {
                PropertyAnimation {
                    properties: "border.color, color"
                    duration: 150
                }
            }
        }

        Image {
            id: userPicture

            enabled: config.UserPictureEnabled === "true"

            source: ""
            height: inputWidth / 1.5
            width: inputWidth / 1.5
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectCrop
            visible: false
            layer.enabled: true
        }

        Item {
            id: mask

            anchors.fill: userPicture
            visible: false
            layer.enabled: true

            Rectangle {
                anchors.fill: parent
                radius: inputWidth / 3
            }
        }

        MultiEffect {
            anchors.fill: userPicture
            source: userPicture
            maskEnabled: true
            maskSource: mask

            enabled: config.UserPictureEnabled === "true"
            visible: config.UserPictureEnabled === "true"
        }

        Popup {
            id: incorrectPopup

            height: incorrectText.paintedHeight * 2
            width: inputWidth
            y: (pictureBorder.height - height) / 2
            onOpened: incorrectTimer.start()

            Timer {
                id: incorrectTimer

                interval: 3000
                onTriggered: incorrectPopup.close()
            }

            background: Rectangle {
                radius: config.Radius
                color: config.PopupColor
            }

            contentItem: Text {
                id: incorrectText

                font {
                    family: config.FontFamily
                    pointSize: config.FontSize
                    bold: true
                }

                renderType: Text.NativeRendering
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: config.PopupActiveColor
                text: "Incorrect username\nor password!"
            }

            enter: Transition {
                ParallelAnimation {
                    NumberAnimation {
                        property: "opacity"
                        from: 0
                        to: 1
                        duration: 400
                        easing.type: Easing.OutExpo
                    }

                    NumberAnimation {
                        property: "x"
                        from: incorrectPopup.x - (inputWidth * 0.1)
                        to: incorrectPopup.x
                        duration: 500
                        easing.type: Easing.OutElastic
                    }
                }
            }

            exit: Transition {
                NumberAnimation {
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 300
                    easing.type: Easing.OutExpo
                }
            }
        }
    }

    UserFieldPanel {
        id: usernameField

        height: inputHeight
        width: inputWidth
    }

    Connections {
        function onLoginSucceeded() {}

        function onLoginFailed() {
            incorrectPopup.open();
        }

        target: sddm
    }
}
