/*
 * Copyright (C) 2016 Jens Drescher, Germany
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0

Page
{
    allowedOrientations: Orientation.All
    id: id_page_mediapage
    property variant bSoundPressed:false
    property bool bPushNumbersPage: true

    onStatusChanged:
    {
        if (status == PageStatus.Active && bPushNumbersPage)
        {
            console.log("SecondPage: pushAttach of NumbersPage!!!");
            bPushNumbersPage = false
            pageStack.pushAttached(Qt.resolvedUrl("NumbersPage.qml"));
        }
    } 

    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: id_Column_FirstCol.height + Theme.paddingLarge + id_Column_SecondCol.height + Theme.paddingLarge + id_Column_ThirdCol.height + Theme.paddingLarge

        Column
        {
            id: id_Column_FirstCol

            spacing: Theme.paddingSmall
            width: parent.width

            PageHeader { title: "Play Media" }

            Row
            {
                spacing: Theme.paddingSmall
                width: parent.width

                Button
                {
                    width: parent.width/4;
                    text: "Rec"
                    onClicked:
                    {
                        id_CppTools.sSendCommand("key r");
                    }
                    Image
                    {
                        width: 32;
                        height: 32;
                        source: "../ilocationcon-m-rec.png"
                    }
                }
                Button
                {
                    width: parent.width/4;
                    text: "Stop"
                    onClicked:
                    {
                        id_CppTools.sSendCommand("key stop");
                    }
                    Image
                    {
                        width: 32;
                        height: 32;
                        source: "../icon-m-stop.png"
                    }
                }
                Button
                {
                    width: parent.width/4;
                    text: "Pause"
                    onClicked:
                    {
                        id_CppTools.sSendCommand("play speed pause");
                    }
                    Image
                    {
                        width: 32;
                        height: 32;
                        source: "image://theme/icon-m-pause"
                    }
                }
                Button
                {
                    width: parent.width/4;
                    text: "Play"
                    onClicked:
                    {
                        id_CppTools.sSendCommand("play speed normal");
                    }
                    Image
                    {
                        width: 32;
                        height: 32;
                        source: "image://theme/icon-m-play"
                    }
                }
            }
            Row
            {
                spacing: Theme.paddingSmall
                width: parent.width

                Button
                {
                    width: parent.width/4;
                    text: "Prev"
                    onClicked:
                    {
                        id_CppTools.sSendCommand("play seek backward");
                    }
                    Image
                    {
                        width: 32;
                        height: 32;
                        source: "image://theme/icon-m-previous"
                    }
                }
                Button
                {
                    width: parent.width/4;
                    text: "Rew"
                    onClicked:
                    {                       
                        id_CppTools.sSendCommand("key left");
                    }
                }
                Button
                {
                    width: parent.width/4;
                    text: "FF"
                    onClicked:
                    {                        
                        id_CppTools.sSendCommand("key right");
                    }
                }
                Button
                {
                    width: parent.width/4;
                    text: "Next"
                    onClicked:
                    {
                        id_CppTools.sSendCommand("play seek forward");
                    }
                    Image
                    {
                        width: 32;
                        height: 32;
                        source: "image://theme/icon-m-next"
                    }
                }
            }
        }
        Item
        {
            id: id_Item_Separator
            anchors.top: id_Column_FirstCol.bottom;
            width: parent.width
            height: Theme.paddingLarge
        }
        Column
        {
            id: id_Column_SecondCol
            anchors.top: id_Item_Separator.bottom;
            spacing: Theme.paddingSmall
            width: parent.width

            Row
            {
                spacing: Theme.paddingSmall
                width: parent.width

                Button
                {
                    width: parent.width/3;
                    text: "Info"
                    onClicked:
                    {                        
                        id_CppTools.sSendCommand("key i");
                    }
                    Image
                    {
                        width: 32;
                        height: 32;
                        source: "image://theme/icon-m-about"
                    }
                }
                Button
                {
                    width: parent.width/3;
                    text: "Menu"
                    onClicked:
                    {
                        id_CppTools.sSendCommand("key m");
                    }
                    Image
                    {
                        width: 32;
                        height: 32;
                        source: "image://theme/icon-m-menu"
                    }
                }
                Button
                {
                    width: parent.width/3;
                    text: "Guide"
                    onClicked:
                    {
                        id_CppTools.sSendCommand("key s");
                    }
                    Image
                    {
                        width: 32;
                        height: 32;
                        source: "image://theme/icon-m-note"
                    }
                }
            }           
            Row
            {
                spacing: Theme.paddingSmall
                width: parent.width

                Button
                {
                    width: parent.width/3;
                    text: "-"
                    onClicked:
                    {
                        id_CppTools.sSendCommand("key [");
                    }
                    Image
                    {
                        width: 32;
                        height: 32;
                        source: "../icon-m-quiet.png"
                    }
                }
                Button
                {
                    width: parent.width/3;
                    text: "Mute"
                    onClicked:
                    {
                        id_CppTools.sSendCommand("key |");
                    }
                    Image
                    {
                        width: 32;
                        height: 32;
                        source: "image://theme/icon-m-speaker-mute"
                    }
                }
                Button
                {
                    width: parent.width/3;
                    text: "+"
                    onClicked:
                    {
                        id_CppTools.sSendCommand("key ]");
                    }
                    Image
                    {
                        width: 32;
                        height: 32;
                        source: "image://theme/icon-m-speaker"
                    }
                }                                
            }           
            Slider
            {
                id: idSLDPlaySlider
                value: 50
                minimumValue: 0
                maximumValue: 100
                enabled: true
                width: parent.width
                handleVisible: true
                valueText : "Test Text"
                label: "Test Label"
                visible: bMythPlayback
            }
            Row
            {
                width: parent.width
                visible: bMythPlayback
                Image
                {
                    source: "../icon-m-quiet.png"
                }
                Slider
                {
                    id: idSLDVolumeSlider
                    value: iVolumePercent
                    minimumValue: 0
                    maximumValue: 100
                    enabled: true
                    width: parent.width/1.5
                    handleVisible: true
                    valueText : ""
                    label: "Volume"
                    visible: bMythPlayback
                    onValueChanged:
                    {
                        idSLDVolumeSlider.valueText = Math.ceil(idSLDVolumeSlider.value) + "%";
                    }
                    onPressed:
                    {
                        bSoundPressed = true;
                    }
                    onReleased:
                    {
                        //Set volume to selected value
                        id_CppTools.sSendCommand("play volume " + Math.ceil(idSLDVolumeSlider.value) + "%");
                        bSoundPressed = false;
                    }
                }
                Image
                {
                    source: "image://theme/icon-m-speaker"
                }
            }
        }
        Item
        {
            id: id_Item_Separator2
            anchors.top: id_Column_SecondCol.bottom;
            width: parent.width
            height: Theme.paddingLarge
        }
        Column
        {
            id: id_Column_ThirdCol
            anchors.top: id_Item_Separator2.bottom;
            width: parent.width
            spacing: Theme.paddingSmall
            anchors.topMargin: Theme.paddingLarge

            Grid
            {
                columns: 3;
                rows: 3;
                width: parent.width;
                spacing: Theme.paddingSmall;

                Rectangle { color: "transparent"; width: 1; height: 1; }
                Button
                {
                    width: parent.width/3;
                    text: ""
                    onClicked:
                    {
                        id_CppTools.sSendCommand("key up");
                    }
                    Image
                    {
                        source: "image://theme/icon-m-up"
                    }
                }
                Rectangle { color: "transparent"; width: 1; height: 1; }
                Button
                {
                    width: parent.width/3;
                    text: ""
                    onClicked:
                    {
                        id_CppTools.sSendCommand("key left");
                    }
                    Image
                    {
                        source: "image://theme/icon-m-left"
                    }
                }
                Button
                {
                    width: parent.width/3;
                    text: "OK"
                    onClicked:
                    {
                        id_CppTools.sSendCommand("key enter");
                    }
                    Image
                    {
                        source: "../icon-m-stop.png"
                    }
                }
                Button
                {
                    width: parent.width/3;
                    text: ""
                    onClicked:
                    {
                        id_CppTools.sSendCommand("key right");
                    }
                    Image
                    {
                        source: "image://theme/icon-m-right"
                    }
                }
                Button
                {
                    width: parent.width/3;
                    text: "Back"
                    onClicked:
                    {
                        id_CppTools.sSendCommand("key escape");
                    }
                    Image
                    {
                        source: "image://theme/icon-m-enter"
                    }
                }
                Button
                {
                    width: parent.width/3;
                    text: ""
                    onClicked:
                    {
                        id_CppTools.sSendCommand("key down");
                    }
                    Image
                    {
                        source: "image://theme/icon-m-down"
                    }
                }
                Button
                {
                    width: parent.width/3;
                    visible: false;
                }
            }
        }
    }
}
