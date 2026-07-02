// Config created by RhythmGC https://github.com/RhythmGC/BlueArchive-SDDM-theme
// Copyright (C) 2026 RhythmGC
// Based on https://github.com/MarianArlt/sddm-sugar-dark
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: clock

    width: parent.width * 0.9
    anchors.horizontalCenter: parent.horizontalCenter

    Rectangle {
        anchors.fill: parent
        color: "#0D38BDF8" // soft blue transparent background
        border.color: "#4038BDF8"
        border.width: 1
        radius: 8

        // Small tech style corners
        Rectangle {
            width: 8; height: 1; color: "#38BDF8"
            anchors.left: parent.left; anchors.top: parent.top
        }
        Rectangle {
            width: 1; height: 8; color: "#38BDF8"
            anchors.left: parent.left; anchors.top: parent.top
        }
        Rectangle {
            width: 8; height: 1; color: "#38BDF8"
            anchors.right: parent.right; anchors.top: parent.top
        }
        Rectangle {
            width: 1; height: 8; color: "#38BDF8"
            anchors.right: parent.right; anchors.top: parent.top
        }
        Rectangle {
            width: 8; height: 1; color: "#38BDF8"
            anchors.left: parent.left; anchors.bottom: parent.bottom
        }
        Rectangle {
            width: 1; height: 8; color: "#38BDF8"
            anchors.left: parent.left; anchors.bottom: parent.bottom
        }
        Rectangle {
            width: 8; height: 1; color: "#38BDF8"
            anchors.right: parent.right; anchors.bottom: parent.bottom
        }
        Rectangle {
            width: 1; height: 8; color: "#38BDF8"
            anchors.right: parent.right; anchors.bottom: parent.bottom
        }

        // ── Cybernetic Rotating Ring (behind the time text) ──────────────
        Rectangle {
            id: clockHalo
            width: Math.min(parent.width, parent.height) * 0.76
            height: width
            anchors.centerIn: parent
            color: "transparent"
            border.color: "#1238BDF8" // very faint glowing blue
            border.width: 1.5
            radius: width / 2

            // Inner circle
            Rectangle {
                width: parent.width * 0.8
                height: width
                anchors.centerIn: parent
                color: "transparent"
                border.color: "#0838BDF8"
                border.width: 1
                radius: width / 2
            }

            RotationAnimator {
                target: clockHalo
                from: 0
                to: 360
                duration: 25000
                loops: Animation.Infinite
                running: true
            }
        }

        // ── Corner Diagnostic Indicators ─────────────────────────────────
        Label {
            text: "SYS_STATUS: ACTIVE"
            font.family: root.mainFontFamily
            font.pointSize: root.font.pointSize * 0.52
            font.bold: true
            color: "#38BDF8"
            opacity: 0.4
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: 12
        }
        
        Label {
            text: "LOG_SECURE: OK"
            font.family: root.mainFontFamily
            font.pointSize: root.font.pointSize * 0.52
            font.bold: true
            color: "#38BDF8"
            opacity: 0.4
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 12
        }

        Label {
            text: "SHALE_OS_v1.3"
            font.family: root.mainFontFamily
            font.pointSize: root.font.pointSize * 0.52
            font.bold: true
            color: "#38BDF8"
            opacity: 0.4
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.margins: 12
        }

        Label {
            text: "SYS_NET: SECURED"
            font.family: root.mainFontFamily
            font.pointSize: root.font.pointSize * 0.52
            font.bold: true
            color: "#38BDF8"
            opacity: 0.4
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 12
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 2

            Label {
                id: headerTextLabel
                Layout.alignment: Qt.AlignHCenter
                font.family: root.boldFontFamily
                font.pointSize: root.font.pointSize * 0.8
                font.bold: true
                color: "#81C7F5"
                text: config.HeaderText !== "" ? config.HeaderText : "KIVOTOS STANDARD TIME"
            }

            Label {
                id: timeLabel
                Layout.alignment: Qt.AlignHCenter
                font.family: root.clockFontFamily
                font.pointSize: root.font.pointSize * 4.2
                font.bold: true
                color: "#FFFFFF"
                renderType: Text.QtRendering

                function updateTime() {
                    text = new Date().toLocaleTimeString(Qt.locale(config.Locale), config.HourFormat == "long" ? Locale.LongFormat : config.HourFormat !== "" ? config.HourFormat : Locale.ShortFormat)
                }
            }

            Label {
                id: dateLabel
                Layout.alignment: Qt.AlignHCenter
                font.family: root.mainFontFamily
                font.pointSize: root.font.pointSize * 1.0
                font.bold: true
                color: "#38BDF8"
                renderType: Text.QtRendering

                function updateTime() {
                    text = new Date().toLocaleDateString(Qt.locale(config.Locale), config.DateFormat == "short" ? Locale.ShortFormat : config.DateFormat !== "" ? config.DateFormat : Locale.LongFormat)
                }
            }
        }
    }

    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: {
            dateLabel.updateTime()
            timeLabel.updateTime()
        }
    }

    Component.onCompleted: {
        dateLabel.updateTime()
        timeLabel.updateTime()
    }
}
