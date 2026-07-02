// Config created by RhythmGC https://github.com/RhythmGC/BlueArchive-SDDM-theme
// Copyright (C) 2026 RhythmGC
// Based on https://github.com/MarianArlt/sddm-sugar-dark
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Effects
import QtMultimedia

import "Components"

Pane {
    id: root

    height: config.ScreenHeight || Screen.height
    width: config.ScreenWidth || Screen.ScreenWidth
    padding: config.ScreenPadding

    FontLoader {
        id: openSansRegular
        source: Qt.resolvedUrl("Fonts/OpenSans/OpenSans-Regular.ttf")
    }
    FontLoader {
        id: openSansBold
        source: Qt.resolvedUrl("Fonts/OpenSans/OpenSans-Bold.ttf")
    }
    FontLoader {
        id: orbitron
        source: Qt.resolvedUrl("Fonts/Orbitron Black.ttf")
    }

    property string mainFontFamily: openSansRegular.name
    property string boldFontFamily: openSansBold.name
    property string clockFontFamily: orbitron.name

    property bool isUnlocked: (config.ShowWelcomeScreen !== "true")
    // formReady is set true after card-expand animation finishes
    property bool formReady: (config.ShowWelcomeScreen !== "true")

    // Timer fires after card expand animation (600 ms) to reveal the login form
    Timer {
        id: formRevealTimer
        interval: 620
        repeat: false
        onTriggered: {
            formReady = true;
            form.focusPassword();
        }
    }

    LayoutMirroring.enabled: config.RightToLeftLayout == "true" ? true : Qt.application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    palette.window: config.BackgroundColor
    palette.highlight: config.HighlightBackgroundColor
    palette.highlightedText: config.HighlightTextColor
    palette.buttonText: config.HoverSystemButtonsIconsColor

    font.family: (config.Font && config.Font !== "pixelon") ? config.Font : openSansRegular.name
    font.pointSize: config.FontSize !== "" ? config.FontSize : parseInt(height / 80) || 13

    focus: true

    Keys.onPressed: function(event) {
        if (config.ShowWelcomeScreen == "true" && !isUnlocked) {
            isUnlocked = true;
            formRevealTimer.start();
            event.accepted = true;
        }
    }

    onIsUnlockedChanged: {
        if (isUnlocked && config.ShowWelcomeScreen !== "true") {
            form.focusPassword();
        }
    }

    property bool leftleft: config.HaveFormBackground == "true" &&
                            config.PartialBlur == "false" &&
                            config.FormPosition == "left" &&
                            config.BackgroundHorizontalAlignment == "left"

    property bool leftcenter: config.HaveFormBackground == "true" &&
                              config.PartialBlur == "false" &&
                              config.FormPosition == "left" &&
                              config.BackgroundHorizontalAlignment == "center"

    property bool rightright: config.HaveFormBackground == "true" &&
                              config.PartialBlur == "false" &&
                              config.FormPosition == "right" &&
                              config.BackgroundHorizontalAlignment == "right"

    property bool rightcenter: config.HaveFormBackground == "true" &&
                               config.PartialBlur == "false" &&
                               config.FormPosition == "right" &&
                               config.BackgroundHorizontalAlignment == "center"

    Item {
        id: sizeHelper

        height: parent.height
        width: parent.width
        anchors.fill: parent
        
        Rectangle {
            id: tintLayer

            height: parent.height
            width: parent.width
            anchors.fill: parent
            z: 1
            color: config.DimBackgroundColor
            opacity: config.DimBackground
        }

        // ── The Morphing Card Backdrop ──────────────────────────────────
        Rectangle {
            id: welcomeCard
            
            // Starts centered, then morphs to targetLoginForm position/size
            width: !isUnlocked ? Math.min(parent.width * 0.38, 560) : (parent.width / 3.2)
            height: !isUnlocked ? Math.min(parent.height * 0.52, 480) : (parent.height * 0.82)
            
            x: !isUnlocked 
               ? (parent.width - width) / 2 
               : (config.FormPosition === "left" 
                  ? parent.width * 0.05 
                  : (config.FormPosition === "right" 
                     ? parent.width - width - parent.width * 0.05 
                     : (parent.width - width) / 2))
            
            y: (parent.height - height) / 2
            radius: !isUnlocked ? 20 : 16
            
            z: 1

            // Smooth animations for morphing!
            Behavior on width  { NumberAnimation { duration: 600; easing.type: Easing.InOutQuart } }
            Behavior on height { NumberAnimation { duration: 600; easing.type: Easing.InOutQuart } }
            Behavior on x      { NumberAnimation { duration: 600; easing.type: Easing.InOutQuart } }
            Behavior on y      { NumberAnimation { duration: 600; easing.type: Easing.InOutQuart } }
            Behavior on radius { NumberAnimation { duration: 600; easing.type: Easing.InOutQuart } }

            // Frosted glass background
            color: config.FormBackgroundColor || "#121625"
            opacity: config.PartialBlur == "true" ? 0.85 : 0.95
            
            border.color: "#5900A3EC"
            border.width: 1.5

            // Corner accents (always hug the card edges as it morphs!)
            Rectangle {
                width: 14; height: 2; color: "#00A3EC"
                anchors.left: parent.left; anchors.leftMargin: 1
                anchors.top: parent.top
            }
            Rectangle {
                width: 2; height: 14; color: "#00A3EC"
                anchors.left: parent.left
                anchors.top: parent.top; anchors.topMargin: 1
            }
            Rectangle {
                width: 14; height: 2; color: "#00A3EC"
                anchors.right: parent.right; anchors.rightMargin: 1
                anchors.top: parent.top
            }
            Rectangle {
                width: 2; height: 14; color: "#00A3EC"
                anchors.right: parent.right
                anchors.top: parent.top; anchors.topMargin: 1
            }
            Rectangle {
                width: 14; height: 2; color: "#00A3EC"
                anchors.left: parent.left; anchors.leftMargin: 1
                anchors.bottom: parent.bottom
            }
            Rectangle {
                width: 2; height: 14; color: "#00A3EC"
                anchors.left: parent.left
                anchors.bottom: parent.bottom; anchors.bottomMargin: 1
            }
            Rectangle {
                width: 14; height: 2; color: "#00A3EC"
                anchors.right: parent.right; anchors.rightMargin: 1
                anchors.bottom: parent.bottom
            }
            Rectangle {
                width: 2; height: 14; color: "#00A3EC"
                anchors.right: parent.right
                anchors.bottom: parent.bottom; anchors.bottomMargin: 1
            }

            // ── Welcome Screen Content (fades out on unlock) ─────────────
            Column {
                id: welcomeContent
                anchors.centerIn: parent
                spacing: welcomeCard.height * 0.05
                opacity: !isUnlocked ? 1.0 : 0.0
                visible: opacity > 0.0
                
                Behavior on opacity { NumberAnimation { duration: 250; easing.type: Easing.OutQuad } }

                // Schale logo
                Image {
                    id: schaleLogoWelcome
                    source: Qt.resolvedUrl("Assets/logo/Schale_logo_emblem.png")
                    width:  welcomeCard.width * 0.38
                    height: width
                    fillMode: Image.PreserveAspectFit
                    anchors.horizontalCenter: parent.horizontalCenter
                    mipmap: true
                }

                // OS name logo
                Image {
                    source: Qt.resolvedUrl("Assets/logo/BlueArchiveOS-Linux_sharp.png")
                    width:  welcomeCard.width * 0.72
                    height: width * 0.3125
                    fillMode: Image.PreserveAspectFit
                    anchors.horizontalCenter: parent.horizontalCenter
                    mipmap: true
                }

                // Pulsing "Press any key" hint
                Label {
                    text: "PRESS ANY KEY OR CLICK TO AUTHORIZE"
                    font.family: root.mainFontFamily
                    font.pointSize: root.font.pointSize * 0.72
                    color: "#81C7F5"
                    anchors.horizontalCenter: parent.horizontalCenter

                    SequentialAnimation on opacity {
                        loops: Animation.Infinite
                        running: !isUnlocked
                        NumberAnimation { from: 0.3; to: 1.0; duration: 1200; easing.type: Easing.InOutQuad }
                        NumberAnimation { from: 1.0; to: 0.3; duration: 1200; easing.type: Easing.InOutQuad }
                    }
                }
            }

            // ── Login Form Content (fades in after expansion completes) ──
            LoginForm {
                id: form
                anchors.fill: parent
                anchors.margins: 15
                
                opacity: formReady ? 1.0 : 0.0
                visible: opacity > 0.0

                Behavior on opacity { NumberAnimation { duration: 450; easing.type: Easing.OutQuad } }
            }
        }

        // Fullscreen lock MouseArea to capture clicks
        MouseArea {
            id: lockScreenMouseArea
            anchors.fill: parent
            z: 10 // high z-index to block other inputs when locked
            enabled: !isUnlocked
            onClicked: {
                isUnlocked = true;
                formRevealTimer.start();
            }
        }

        Loader {
            id: virtualKeyboard
            source: "Components/VirtualKeyboard.qml"

            // x * 0.4 = x / 2.5
            width: config.KeyboardSize == "" ? parent.width * 0.4 : parent.width * config.KeyboardSize
            anchors.bottom: parent.bottom
            anchors.left: config.VirtualKeyboardPosition == "left" ? parent.left : undefined;
            anchors.horizontalCenter: config.VirtualKeyboardPosition == "center" ? parent.horizontalCenter : undefined;
            anchors.right: config.VirtualKeyboardPosition == "right" ? parent.right : undefined;
            z: 1
            
            state: "hidden"
            property bool keyboardActive: item ? item.active : false

            function switchState() { state = state == "hidden" ? "visible" : "hidden"}
            states: [
                State {
                    name: "visible"
                    PropertyChanges {
                        target: virtualKeyboard
                        y: root.height - virtualKeyboard.height
                        opacity: 1
                    }
                },
                State {
                    name: "hidden"
                    PropertyChanges {
                        target: virtualKeyboard
                        y: root.height - root.height/4
                        opacity: 0
                    }
                }
            ]
            transitions: [
                Transition {
                    from: "hidden"
                    to: "visible"
                    SequentialAnimation {
                        ScriptAction {
                            script: {
                                virtualKeyboard.item.activated = true;
                                Qt.inputMethod.show();
                            }
                        }
                        ParallelAnimation {
                            NumberAnimation {
                                target: virtualKeyboard
                                property: "y"
                                duration: 100
                                easing.type: Easing.OutQuad
                            }
                            OpacityAnimator {
                                target: virtualKeyboard
                                duration: 100
                                easing.type: Easing.OutQuad
                            }
                        }
                    }
                },
                Transition {
                    from: "visible"
                    to: "hidden"
                    SequentialAnimation {
                        ParallelAnimation {
                            NumberAnimation {
                                target: virtualKeyboard
                                property: "y"
                                duration: 100
                                easing.type: Easing.InQuad
                            }
                            OpacityAnimator {
                                target: virtualKeyboard
                                duration: 100
                                easing.type: Easing.InQuad
                            }
                        }
                        ScriptAction {
                            script: {
                                virtualKeyboard.item.activated = false;
                                Qt.inputMethod.hide();
                            }
                        }
                    }
                }
            ]
        }
        
        Image {
            id: backgroundPlaceholderImage

            z: 10
            source: config.BackgroundPlaceholder
            visible: false
        }

        AnimatedImage {
            id: backgroundImage
            
            MediaPlayer {
                id: player
                
                videoOutput: videoOutput
                autoPlay: true
                playbackRate: config.BackgroundSpeed == "" ? 1.0 : config.BackgroundSpeed
                loops: -1
                onPlayingChanged: {
                    console.log("Video started.")
                    backgroundPlaceholderImage.visible = false;
                }
            }

            VideoOutput {
                id: videoOutput
                
                fillMode: config.CropBackground == "true" ? VideoOutput.PreserveAspectCrop : VideoOutput.PreserveAspectFit
                anchors.fill: parent
            }

            height: parent.height
            width: config.HaveFormBackground == "true" && config.FormPosition != "center" && config.PartialBlur != "true" ? parent.width - formBackground.width : parent.width
            anchors.left: leftleft || leftcenter ? formBackground.right : undefined
            anchors.right: rightright || rightcenter ? formBackground.left : undefined

            horizontalAlignment: config.BackgroundHorizontalAlignment == "left" ?
                                 Image.AlignLeft :
                                 config.BackgroundHorizontalAlignment == "right" ?
                                 Image.AlignRight : Image.AlignHCenter

            verticalAlignment: config.BackgroundVerticalAlignment == "top" ?
                               Image.AlignTop :
                               config.BackgroundVerticalAlignment == "bottom" ?
                               Image.AlignBottom : Image.AlignVCenter

            speed: config.BackgroundSpeed == "" ? 1.0 : config.BackgroundSpeed
            paused: config.PauseBackground == "true" ? 1 : 0
            fillMode: config.CropBackground == "true" ? Image.PreserveAspectCrop : Image.PreserveAspectFit
            asynchronous: true
            cache: true
            clip: true
            mipmap: true

            Component.onCompleted:{
                var fileType = config.Background.substring(config.Background.lastIndexOf(".") + 1)
                const videoFileTypes = ["avi", "mp4", "mov", "mkv", "m4v", "webm"];
                if (videoFileTypes.includes(fileType)) {
                    backgroundPlaceholderImage.visible = true;
                    player.source = Qt.resolvedUrl(config.Background)
                    player.play();
                }
                else{
                    backgroundImage.source = config.background || config.Background
                }
            }
        }

        MouseArea {
            anchors.fill: backgroundImage
            onClicked: parent.forceActiveFocus()
        }

        ShaderEffectSource {
            id: blurMask

            height: parent.height
            width: form.width
            anchors.centerIn: form

            sourceItem: backgroundImage
            sourceRect: Qt.rect(x,y,width,height)
            visible: config.FullBlur == "true" || config.PartialBlur == "true" ? true : false
        }

        MultiEffect {
            id: blur
            
            height: parent.height
            width: (config.ShowWelcomeScreen == "true" || config.FullBlur == "true") ? parent.width : form.width
            anchors.centerIn: (config.ShowWelcomeScreen == "true" || config.FullBlur == "true") ? backgroundImage : form

            source: (config.ShowWelcomeScreen == "true" || config.FullBlur == "true") ? backgroundImage : blurMask
            blurEnabled: true
            autoPaddingEnabled: false
            
            // Dynamic blur animation
            blur: (config.ShowWelcomeScreen == "true" && !isUnlocked) ? 0.0 : (config.Blur == "" ? 2.5 : config.Blur)
            blurMax: config.BlurMax == "" ? 48 : config.BlurMax
            visible: config.FullBlur == "true" || config.PartialBlur == "true" || config.ShowWelcomeScreen == "true"

            Behavior on blur { NumberAnimation { duration: 600; easing.type: Easing.OutQuad } }
        }
    }
}
