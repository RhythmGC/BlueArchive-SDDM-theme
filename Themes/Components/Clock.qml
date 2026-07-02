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
        color: "#0D00A3EC" // soft blue transparent background
        border.color: "#4000A3EC"
        border.width: 1
        radius: 8

        // Small tech style corners
        Rectangle {
            width: 8; height: 1; color: "#00A3EC"
            anchors.left: parent.left; anchors.top: parent.top
        }
        Rectangle {
            width: 1; height: 8; color: "#00A3EC"
            anchors.left: parent.left; anchors.top: parent.top
        }
        Rectangle {
            width: 8; height: 1; color: "#00A3EC"
            anchors.right: parent.right; anchors.top: parent.top
        }
        Rectangle {
            width: 1; height: 8; color: "#00A3EC"
            anchors.right: parent.right; anchors.top: parent.top
        }
        Rectangle {
            width: 8; height: 1; color: "#00A3EC"
            anchors.left: parent.left; anchors.bottom: parent.bottom
        }
        Rectangle {
            width: 1; height: 8; color: "#00A3EC"
            anchors.left: parent.left; anchors.bottom: parent.bottom
        }
        Rectangle {
            width: 8; height: 1; color: "#00A3EC"
            anchors.right: parent.right; anchors.bottom: parent.bottom
        }
        Rectangle {
            width: 1; height: 8; color: "#00A3EC"
            anchors.right: parent.right; anchors.bottom: parent.bottom
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
                color: "#00A3EC"
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
