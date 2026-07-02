// Config created by RhythmGC https://github.com/RhythmGC/BlueArchive-SDDM-theme
// Copyright (C) 2026 RhythmGC
// Based on https://github.com/MarianArlt/sddm-sugar-dark
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import SddmComponents 2.0 as SDDM

ColumnLayout {
    id: formContainer
    SDDM.TextConstants { id: textConstants }

    property int p: config.ScreenPadding == "" ? 0 : config.ScreenPadding
    property string a: config.FormPosition

    function focusPassword() {
        input.focusPassword();
    }

    spacing: 12

    // Beautiful SCHALE Header
    Item {
        id: headerContainer
        Layout.fillWidth: true
        Layout.preferredHeight: 70
        Layout.alignment: Qt.AlignHCenter
        
        RowLayout {
            anchors.fill: parent
            anchors.margins: 15
            spacing: 12
            
            // Actual Schale Logo Image
            Image {
                source: Qt.resolvedUrl("../Assets/logo/Schale_logo_emblem.png")
                Layout.preferredWidth: 44
                Layout.preferredHeight: 44
                fillMode: Image.PreserveAspectFit
                mipmap: true
            }
            
            ColumnLayout {
                spacing: 2
                Layout.fillWidth: true
                
                Label {
                    text: "S C H A L E"
                    font.family: root.boldFontFamily
                    font.pointSize: root.font.pointSize * 1.1
                    font.bold: true
                    color: "#00A3EC"
                }
                Label {
                    text: "SYSTEM OPERATION TERMINAL"
                    font.family: root.mainFontFamily
                    font.pointSize: root.font.pointSize * 0.65
                    color: "#81C7F5"
                    opacity: 0.8
                }
            }
        }
        
        // Thin glowing header divider
        Rectangle {
            width: parent.width - 30
            height: 1
            color: "#4000A3EC"
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    Clock {
        id: clock

        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        Layout.preferredHeight: root.height * 0.25
        Layout.fillWidth: true
        Layout.leftMargin: 20
        Layout.rightMargin: 20
    }

    Input {
        id: input

        Layout.alignment: Qt.AlignVCenter
        Layout.preferredHeight: root.height * 0.22
        Layout.fillWidth: true
        Layout.topMargin: 5
    }

    SystemButtons {
        id: systemButtons

        Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
        Layout.preferredHeight: root.height * 0.12
        Layout.maximumHeight: root.height * 0.12
        Layout.leftMargin: p != "0" ? a == "left" ? -p : a == "right" ? p : 0 : 0
        
        exposedSession: input.exposeSession
    }
    
    SessionButton {
        id: sessionSelect

        Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
        Layout.preferredHeight: root.height / 54
        Layout.maximumHeight: root.height / 54
        Layout.leftMargin: p != "0" ? a == "left" ? -p : a == "right" ? p : 0 : 0
    }

    VirtualKeyboardButton {
        id: virtualKeyboardButton

        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
        Layout.preferredHeight: root.height / 27
        Layout.maximumHeight: root.height / 27
        Layout.leftMargin: p != "0" ? a == "left" ? -p : a == "right" ? p : 0 : 0
    }
}
