// Config created by RhythmGC https://github.com/RhythmGC/BlueArchive-SDDM-theme
// Copyright (C) 2026 RhythmGC
// Based on https://github.com/MarianArlt/sddm-sugar-dark
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

RowLayout {
    id: systemButtonsRow
    spacing: root.font.pointSize * 1.5
    Layout.alignment: Qt.AlignHCenter

    property var shutdown: ["Shutdown", config.TranslateShutdown || textConstants.shutdown, sddm.canPowerOff]
    property var reboot: ["Reboot", config.TranslateReboot || textConstants.reboot, sddm.canReboot]
    property var suspend: ["Suspend", config.TranslateSuspend || textConstants.suspend, sddm.canSuspend]
    property var hibernate: ["Hibernate", config.TranslateHibernate || textConstants.hibernate, sddm.canHibernate]

    property ComboBox exposedSession

    Repeater {
        id: systemButtons
        model: [shutdown, reboot, suspend, hibernate]

        RoundButton {
            id: sysBtn
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            text: modelData[1]
            font.family: root.mainFontFamily
            font.pointSize: root.font.pointSize * 0.75
            font.bold: true
            
            icon.source: modelData ? Qt.resolvedUrl("../Assets/" + modelData[0] + ".svg") : ""
            icon.height: root.font.pointSize * 1.8
            icon.width: root.font.pointSize * 1.8
            icon.color: hovered ? "#00A3EC" : (config.SystemButtonsIconsColor || "#81C7F5")
            
            palette.buttonText: hovered ? "#00A3EC" : (config.SystemButtonsIconsColor || "#81C7F5")
            display: AbstractButton.TextUnderIcon
            visible: config.HideSystemButtons != "true" && (config.BypassSystemButtonsChecks == "true" ? 1 : modelData[2])
            hoverEnabled: true
            
            scale: hovered ? 1.08 : 1.0
            Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }

            background: Rectangle {
                implicitWidth: root.font.pointSize * 4.8
                implicitHeight: root.font.pointSize * 4.8
                color: sysBtn.hovered ? "#1F00A3EC" : "#0AFFFFFF"
                border.color: sysBtn.hovered ? "#00A3EC" : "#1FFFFFFF"
                border.width: sysBtn.hovered ? 1.5 : 1
                radius: width / 2
                
                Behavior on color { ColorAnimation { duration: 150 } }
                Behavior on border.color { ColorAnimation { duration: 150 } }
            }

            Keys.onReturnPressed: clicked()
            onClicked: {
                parent.forceActiveFocus()
                index == 0 ? sddm.powerOff() : index == 1 ? sddm.reboot() : index == 2 ? sddm.suspend() : sddm.hibernate()
            }
            KeyNavigation.left: index > 0 ? systemButtons.itemAt(index-1) : null
            KeyNavigation.right: index < 3 ? systemButtons.itemAt(index+1) : null
        }
    }
}