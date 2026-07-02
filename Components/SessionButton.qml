// Config created by RhythmGC https://github.com/RhythmGC/BlueArchive-SDDM-theme
// Copyright (C) 2026 RhythmGC
// Based on https://github.com/MarianArlt/sddm-sugar-dark
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: sessionButton

    height: root.font.pointSize * 2.2
    width: parent.width * 0.8
    anchors.horizontalCenter: parent.horizontalCenter
    
    property var selectedSession: selectSession.currentIndex
    property string textConstantSession
    property int loginButtonWidth
    property ComboBox exposeSession: selectSession

    ComboBox {
        id: selectSession
        anchors.fill: parent

        hoverEnabled: true
        model: sessionModel
        currentIndex: model.lastIndex
        textRole: "name"
        
        Keys.onPressed: function(event) {
            if ((event.key == Qt.Key_Left || event.key == Qt.Key_Right) && !popup.opened) {
                popup.open();
            }
        }

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
                color: selectSession.highlightedIndex === index ? "#FFFFFF" : "#E2E8F0"
            }
            
            background: Rectangle {
                color: selectSession.highlightedIndex === index ? "#38BDF8" : "transparent"
                radius: 4
            }
        }

        indicator: Canvas {
            id: canvas
            x: selectSession.width - width - 12
            y: selectSession.height / 2 - height / 2
            width: 8
            height: 5
            contextType: "2d"

            onPaint: {
                context.reset();
                context.moveTo(0, 0);
                context.lineTo(width, 0);
                context.lineTo(width / 2, height);
                context.closePath();
                context.fillStyle = selectSession.hovered ? "#38BDF8" : (config.SessionButtonTextColor || "#81C7F5");
                context.fill();
            }

            Connections {
                target: selectSession
                function onHoveredChanged() { canvas.requestPaint(); }
            }
        }

        contentItem: Text {
            id: displayedItem
            verticalAlignment: Text.AlignVCenter
            leftPadding: 12
            
            text: (config.TranslateSessionSelection || "Session") + ": " + selectSession.currentText
            color: selectSession.hovered ? "#FFFFFF" : (config.SessionButtonTextColor || "#81C7F5")
            font.pointSize: root.font.pointSize * 0.85
            font.family: root.mainFontFamily
            font.bold: true

            Behavior on color { ColorAnimation { duration: 150 } }
        }

        background: Rectangle {
            color: selectSession.hovered ? "#1438BDF8" : "#08FFFFFF"
            border.color: selectSession.hovered ? "#38BDF8" : "#1AFFFFFF"
            border.width: 1
            radius: 8
            
            Behavior on color { ColorAnimation { duration: 150 } }
            Behavior on border.color { ColorAnimation { duration: 150 } }
        }

        popup: Popup {
            id: popupHandler
            implicitHeight: contentItem.implicitHeight > 200 ? 200 : contentItem.implicitHeight
            width: sessionButton.width
            y: parent.height + 4
            x: 0
            padding: 6

            contentItem: ListView {
                implicitHeight: contentHeight
                clip: true
                model: selectSession.popup.visible ? selectSession.delegateModel : null
                currentIndex: selectSession.highlightedIndex
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
}
