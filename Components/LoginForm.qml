// Config created by RhythmGC https://github.com/RhythmGC/BlueArchive-SDDM-theme
// Copyright (C) 2026 RhythmGC
// Based on https://github.com/MarianArlt/sddm-sugar-dark
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import SddmComponents 2.0 as SDDM

RowLayout {
    id: formContainer
    SDDM.TextConstants { id: textConstants }

    property int p: config.ScreenPadding == "" ? 0 : config.ScreenPadding
    property string a: config.FormPosition

    function focusPassword() {
        input.focusPassword();
    }

    spacing: root.font.pointSize * 2.5

    // ── LEFT CONSOLE PANEL: Header, Clock & System ───────────────────
    ColumnLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.preferredWidth: parent.width * 0.46
        spacing: root.font.pointSize * 1.5

        // Beautiful SCHALE Header
        Item {
            id: headerContainer
            Layout.fillWidth: true
            Layout.preferredHeight: root.font.pointSize * 6.0
            
            // Left: Schale logo
            Image {
                id: headerLogo
                source: Qt.resolvedUrl("../Assets/logo/Schale_logo_emblem.png")
                height: parent.height * 0.8
                width: height
                fillMode: Image.PreserveAspectFit
                mipmap: true
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
            }

            // Right: title text block
            Column {
                anchors.left: headerLogo.right
                anchors.leftMargin: root.font.pointSize * 0.8
                anchors.verticalCenter: parent.verticalCenter
                spacing: root.font.pointSize * 0.15

                Label {
                    text: "S.C.H.A.L.E"
                    font.family: root.boldFontFamily
                    font.pointSize: root.font.pointSize * 1.3
                    font.bold: true
                    color: "#38BDF8"
                }
                Label {
                    text: "SYSTEM OPERATION TERMINAL"
                    font.family: root.mainFontFamily
                    font.pointSize: root.font.pointSize * 0.65
                    color: "#81C7F5"
                    opacity: 0.8
                }
            }

            // Thin glowing header divider
            Rectangle {
                width: parent.width
                height: 1
                color: "#4038BDF8"
                anchors.bottom: parent.bottom
            }
        }

        // Digital Clock Panel
        Clock {
            id: clock
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: root.font.pointSize * 14
        }

        // Spacer to push power options down
        Item {
            Layout.fillHeight: true
        }

        // System Buttons (Shutdown, Reboot)
        SystemButtons {
            id: systemButtons
            Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
            Layout.preferredHeight: root.font.pointSize * 4
            exposedSession: input.exposeSession
        }
    }

    // ── RIGHT CONSOLE PANEL: Credentials Input ───────────────────────
    ColumnLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.preferredWidth: parent.width * 0.54
        spacing: root.font.pointSize * 1.2

        // Spacer to push input fields down for visual balance
        Item {
            Layout.fillHeight: true
        }

        // Username, Password & Login Button
        Input {
            id: input
            Layout.fillWidth: true
            Layout.preferredHeight: implicitHeight
        }

        // Session Desktop Selector
        SessionButton {
            id: sessionSelect
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: root.font.pointSize * 2.8
            Layout.fillWidth: true
        }

        // On-screen Virtual Keyboard Button
        VirtualKeyboardButton {
            id: virtualKeyboardButton
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: root.font.pointSize * 2.8
            Layout.fillWidth: true
        }

        // Spacer at the bottom
        Item {
            Layout.fillHeight: true
        }
    }
}
