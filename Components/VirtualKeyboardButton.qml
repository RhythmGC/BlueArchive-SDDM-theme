// Config created by RhythmGC https://github.com/RhythmGC/BlueArchive-SDDM-theme
// Copyright (C) 2026 RhythmGC
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html

import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: virtualKeyboardButtonItem

    height: root.font.pointSize * 2.2
    width: parent.width * 0.8
    anchors.horizontalCenter: parent.horizontalCenter

    Button {
        id: virtualKeyboardButton
        anchors.fill: parent

        visible: virtualKeyboard.status == Loader.Ready && config.HideVirtualKeyboard == "false"
        checkable: true
        onClicked: virtualKeyboard.switchState()
        hoverEnabled: true
        
        Keys.onReturnPressed: {
            toggle();
            virtualKeyboard.switchState();
        }
        Keys.onEnterPressed: {
            toggle();
            virtualKeyboard.switchState();
        }

        contentItem: Text {
            id: virtualKeyboardButtonText
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            text: (virtualKeyboardButton.checked ? (config.TranslateVirtualKeyboardButtonOn || "Virtual Keyboard (on)") : (config.TranslateVirtualKeyboardButtonOff || "Virtual Keyboard (off)")).toUpperCase()
            font.pointSize: root.font.pointSize * 0.8
            font.family: root.mainFontFamily
            font.bold: true
            color: virtualKeyboardButton.hovered ? "#FFFFFF" : (config.VirtualKeyboardButtonTextColor || "#81C7F5")
            
            Behavior on color { ColorAnimation { duration: 150 } }
        }

        background: Rectangle {
            color: virtualKeyboardButton.hovered ? "#1438BDF8" : "#08FFFFFF"
            border.color: virtualKeyboardButton.hovered ? "#38BDF8" : "#1AFFFFFF"
            border.width: 1
            radius: 8
            
            Behavior on color { ColorAnimation { duration: 150 } }
            Behavior on border.color { ColorAnimation { duration: 150 } }
        }
    }
}