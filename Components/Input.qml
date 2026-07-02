// Config created by RhythmGC https://github.com/RhythmGC/BlueArchive-SDDM-theme
// Copyright (C) 2026 RhythmGC
// Based on https://github.com/MarianArlt/sddm-sugar-dark
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

Column {
    id: inputContainer
    
    Layout.fillWidth: true
    spacing: 8

    property ComboBox exposeSession: sessionSelect.exposeSession
    property bool failed: false

    function focusPassword() {
        if (username.text === "") {
            username.forceActiveFocus();
        } else {
            password.forceActiveFocus();
        }
    }

    Item {
        id: errorMessageField
        height: root.font.pointSize * 2.2
        width: parent.width * 0.8
        anchors.horizontalCenter: parent.horizontalCenter

        Label {
            id: errorMessage
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.fill: parent
            
            text: failed ? config.TranslateLoginFailedWarning || textConstants.loginFailed + "!" : keyboard.capsLock ? config.TranslateCapslockWarning || textConstants.capslockWarning : ""
            font.pointSize: root.font.pointSize * 0.85
            font.bold: true
            font.family: root.mainFontFamily
            color: "#FF5E85" // iconic alert pink from Blue Archive
            opacity: (failed || keyboard.capsLock) ? 1.0 : 0.0
            
            Behavior on opacity { NumberAnimation { duration: 150 } }
        }
    }

    Item {
        id: usernameField
        height: root.font.pointSize * 4.5
        width: parent.width * 0.8
        anchors.horizontalCenter: parent.horizontalCenter

        ComboBox {
            id: selectUser
            width: parent.height
            height: parent.height
            anchors.left: parent.left
            z: 2

            model: userModel
            currentIndex: model.lastIndex
            textRole: "name"
            hoverEnabled: true
            onActivated: {
                username.text = currentText
            }

            property var popkey: config.RightToLeftLayout == "true" ? Qt.Key_Right : Qt.Key_Left
            Keys.onPressed: function(event) {
                if (event.key == Qt.Key_Down && !popup.opened)
                    username.forceActiveFocus();
                if ((event.key == Qt.Key_Up || event.key == popkey) && !popup.opened)
                    popup.open();
            }
            KeyNavigation.down: username
            KeyNavigation.right: username

            delegate: ItemDelegate {
                width: popupHandler.width - 10
                anchors.horizontalCenter: popupHandler.horizontalCenter
                
                contentItem: Text {
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    leftPadding: 8

                    text: model.name
                    font.pointSize: root.font.pointSize * 0.9
                    font.family: root.mainFontFamily
                    color: selectUser.highlightedIndex === index ? "#FFFFFF" : "#E2E8F0"
                }
                
                background: Rectangle {
                    color: selectUser.highlightedIndex === index ? "#38BDF8" : "transparent"
                    radius: 4
                }
            }

            indicator: Button {
                id: usernameIcon
                width: selectUser.height
                height: parent.height
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                icon.height: parent.height * 0.28
                icon.width: parent.height * 0.28
                enabled: false
                icon.color: username.activeFocus ? "#38BDF8" : "#99FFFFFF"
                icon.source: Qt.resolvedUrl("../Assets/User.svg")
                
                background: Rectangle { color: "transparent" }
            }

            background: Rectangle { color: "transparent" }

            popup: Popup {
                id: popupHandler
                implicitHeight: contentItem.implicitHeight > 200 ? 200 : contentItem.implicitHeight
                width: usernameField.width
                y: parent.height + 4
                x: 0
                padding: 6

                contentItem: ListView {
                    implicitHeight: contentHeight
                    clip: true
                    model: selectUser.popup.visible ? selectUser.delegateModel : null
                    currentIndex: selectUser.highlightedIndex
                    ScrollIndicator.vertical: ScrollIndicator { }
                }

                background: Rectangle {
                    radius: 8
                    color: "#1E293B"
                    border.color: "#6638BDF8"
                    border.width: 1
                }

                enter: Transition {
                    NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 120 }
                }
            }
        }

        TextField {
            id: username
            anchors.centerIn: parent
            height: root.font.pointSize * 3
            width: parent.width
            horizontalAlignment: TextInput.AlignLeft
            leftPadding: selectUser.width + 10
            rightPadding: 10
            z: 1

            text: config.ForceLastUser == "true" ? selectUser.currentText : null
            color: config.LoginFieldTextColor || "#FFFFFF"
            font.bold: true
            font.family: root.mainFontFamily
            font.capitalization: config.AllowUppercaseLettersInUsernames == "false" ? Font.AllLowercase : Font.MixedCase
            placeholderText: config.TranslatePlaceholderUsername || textConstants.userName
            placeholderTextColor: config.PlaceholderTextColor || "#64748B"
            selectByMouse: true
            renderType: Text.QtRendering
            
            onFocusChanged: {
                if(focus)
                    selectAll()
            }

            background: Rectangle {
                color: username.activeFocus ? "#1438BDF8" : (config.LoginFieldBackgroundColor || "#1E293B")
                opacity: username.activeFocus ? 0.95 : 0.65
                border.color: username.activeFocus ? "#38BDF8" : "#4038BDF8"
                border.width: username.activeFocus ? 1.5 : 1
                radius: 8
                
                Behavior on color { ColorAnimation { duration: 150 } }
                Behavior on border.color { ColorAnimation { duration: 150 } }
                
                // Left accent bar
                Rectangle {
                    width: 3
                    height: parent.height - 8
                    anchors.left: parent.left
                    anchors.leftMargin: 4
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#38BDF8"
                    radius: 1.5
                    opacity: username.activeFocus ? 1.0 : 0.0
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                }
            }
            
            onAccepted: config.AllowUppercaseLettersInUsernames == "false" ? sddm.login(username.text.toLowerCase(), password.text, sessionSelect.selectedSession) : sddm.login(username.text, password.text, sessionSelect.selectedSession)
            KeyNavigation.down: passwordField.children[0] // navigate to password icon/button
        }
    }
    
    Item {
        id: passwordField
        height: root.font.pointSize * 4.5
        width: parent.width * 0.8
        anchors.horizontalCenter: parent.horizontalCenter
        
        Button {
            id: passwordIcon
            height: parent.height
            width: selectUser.height
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            z: 2
            
            icon.height: parent.height * 0.28
            icon.width: parent.height * 0.28
            icon.color: password.activeFocus ? "#38BDF8" : "#99FFFFFF"
            icon.source: checked ? Qt.resolvedUrl("../Assets/Password.svg") : Qt.resolvedUrl("../Assets/Password2.svg")
            checkable: true
            checked: false

            background: Rectangle { color: "transparent" }

            onClicked: toggle()
            Keys.onReturnPressed: toggle()
            Keys.onEnterPressed: toggle()
            KeyNavigation.down: password
        }

        TextField {
            id: password
            height: root.font.pointSize * 3
            width: parent.width
            anchors.centerIn: parent
            horizontalAlignment: TextInput.AlignLeft
            leftPadding: passwordIcon.width + 10
            rightPadding: 10
            
            font.bold: true
            font.family: root.mainFontFamily
            color: config.PasswordFieldTextColor || "#FFFFFF"
            focus: config.PasswordFocus == "true" ? true : false
            echoMode: passwordIcon.checked ? TextInput.Normal : TextInput.Password
            placeholderText: config.TranslatePlaceholderPassword || textConstants.password
            placeholderTextColor: config.PlaceholderTextColor || "#64748B"
            passwordCharacter: "•"
            passwordMaskDelay: config.HideCompletePassword == "true" ? undefined : 1000
            renderType: Text.QtRendering
            selectByMouse: true
            
            background: Rectangle {
                color: password.activeFocus ? "#1438BDF8" : (config.PasswordFieldBackgroundColor || "#1E293B")
                opacity: password.activeFocus ? 0.95 : 0.65
                border.color: password.activeFocus ? "#38BDF8" : "#4038BDF8"
                border.width: password.activeFocus ? 1.5 : 1
                radius: 8
                
                Behavior on color { ColorAnimation { duration: 150 } }
                Behavior on border.color { ColorAnimation { duration: 150 } }
                
                // Left accent bar
                Rectangle {
                    width: 3
                    height: parent.height - 8
                    anchors.left: parent.left
                    anchors.leftMargin: 4
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#38BDF8"
                    radius: 1.5
                    opacity: password.activeFocus ? 1.0 : 0.0
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                }
            }
            onAccepted: config.AllowUppercaseLettersInUsernames == "false" ? sddm.login(username.text.toLowerCase(), password.text, sessionSelect.selectedSession) : sddm.login(username.text, password.text, sessionSelect.selectedSession)
            KeyNavigation.down: loginButton
        }
    }

    Item {
        id: login
        height: root.font.pointSize * 6.5
        width: parent.width * 0.8
        anchors.horizontalCenter: parent.horizontalCenter
        visible: config.HideLoginButton == "true" ? false : true
        
        Button {
            id: loginButton
            height: root.font.pointSize * 3
            implicitWidth: parent.width
            anchors.centerIn: parent
            
            text: (config.TranslateLogin || textConstants.login).toUpperCase()
            enabled: config.AllowEmptyPassword == "true" || username.text != "" && password.text != "" ? true : false
            hoverEnabled: true

            scale: hovered && enabled ? 1.03 : 1.0
            Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }

            contentItem: Text {
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                font.bold: true
                font.pointSize: root.font.pointSize * 0.95
                font.family: root.boldFontFamily
                color: enabled ? "#FFFFFF" : "#64748B"
                text: parent.text
            }

            background: Rectangle {
                id: buttonBackground
                color: parent.enabled ? (parent.hovered ? "#00B4FF" : "#38BDF8") : "#0DFFFFFF"
                border.color: parent.enabled ? "#38BDF8" : "#1AFFFFFF"
                border.width: 1
                radius: 8
                
                Behavior on color { ColorAnimation { duration: 150 } }
                Behavior on border.color { ColorAnimation { duration: 150 } }

                // Inner glow line on hover
                Rectangle {
                    width: parent.width
                    height: 2
                    color: "#40FFFFFF"
                    anchors.top: parent.top
                    visible: loginButton.hovered && loginButton.enabled
                }
            }

            onClicked: config.AllowUppercaseLettersInUsernames == "false" ? sddm.login(username.text.toLowerCase(), password.text, sessionSelect.selectedSession) : sddm.login(username.text, password.text, sessionSelect.selectedSession)
            Keys.onReturnPressed: clicked()
            Keys.onEnterPressed: clicked()
            
            KeyNavigation.down: config.HideSystemButtons == "true" ? virtualKeyboard : systemButtons.children[0]
        }
    }

    Connections {
        target: sddm
        function onLoginSucceeded() {}
        function onLoginFailed() {
            failed = true
            resetError.running ? resetError.stop() && resetError.start() : resetError.start()
        }
    }

    Timer {
        id: resetError
        interval: 2000
        onTriggered: failed = false
        running: false
    }
}
