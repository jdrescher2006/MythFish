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
import "../tools"

Page
{
    allowedOrientations: Orientation.All
    id: id_page_playingpage   

    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: id_Column_FirstCol.height;

        VerticalScrollDecorator {}

        Column
        {
            id: id_Column_FirstCol
            spacing: Theme.paddingSmall
            width: parent.width

            PageHeader { title: qsTr("Now Playing...") }          

            Marquee
            {
                id: idMainMarqueeText;
                interval : 200;
                iWaitBeforeStart: 6;
                width: parent.width;
                text: sPlayingTitle;
            }

            Slider
            {
                id: idSLDVolumeSlider
                value: iVolumePercent
                minimumValue: 0
                maximumValue: 100
                enabled: true
                width: parent.width
                handleVisible: true
                valueText : ""
                label: qsTr("Volume")
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
                    fncSendCommand("play volume " + Math.ceil(idSLDVolumeSlider.value) + "%");
                    bSoundPressed = false;
                }
            }
            Slider
            {
                id: idSLDPlaySlider
                value: iCurrentPlayPosition
                minimumValue: 0
                maximumValue: iMaxPlayPosition
                enabled: true
                width: parent.width
                handleVisible: true
                valueText : sCurrentPlayPosition
                label: sPlayingState
                onPressed:
                {
                    bPlaybackPressed = true;
                }
                onReleased:
                {
                    //Set playback seconds to selected value
                    //multiply by 1000 because Date() requires miliseconds
                    var date = new Date(null);
                    date.setSeconds(idSLDPlaySlider.value);
                    var sDateString = date.toISOString().substr(11, 8);

                    console.log("sDateString: " + sDateString);

                    //fncSendCommand("play seek HH:MM:SS " + sDateString);

                    bPlaybackPressed = false;
                }
            }

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
                        fncSendCommand("key r");
                    }
                    Image
                    {
                        width: 32;
                        height: 32;
                        source: "../icon-m-rec.png"
                    }
                }
                Button
                {
                    width: parent.width/4;
                    text: "Stop"
                    onClicked:
                    {
                        fncSendCommand("key stop");
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
                        fncSendCommand("play speed pause");
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
                        fncSendCommand("play speed normal");
                    }
                    Image
                    {
                        width: 32;
                        height: 32;
                        source: "image://theme/icon-m-play"
                    }
                }
            }
            Item
            {
                width: parent.width
                height: Theme.paddingLarge
            }
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
                        fncSendCommand("key i");
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
                    text: qsTr("Menu")
                    onClicked:
                    {
                        fncSendCommand("key m");
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
                        fncSendCommand("key s");
                    }
                    Image
                    {
                        width: 32;
                        height: 32;
                        source: "image://theme/icon-m-note"
                    }
                }
            }
            Item
            {
                width: parent.width
                height: Theme.paddingLarge
            }
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
                        fncSendCommand("key up");
                    }
                    Image
                    {
                        anchors.verticalCenter: parent.verticalCenter
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
                        fncSendCommand("key left");
                    }
                    Image
                    {
                        anchors.verticalCenter: parent.verticalCenter
                        source: "image://theme/icon-m-left"
                    }
                }
                Button
                {
                    width: parent.width/3;
                    text: "OK"
                    onClicked:
                    {
                        fncSendCommand("key enter");
                    }
                    Image
                    {
                        anchors.verticalCenter: parent.verticalCenter
                        source: "../icon-m-stop.png"
                    }
                }
                Button
                {
                    width: parent.width/3;
                    text: ""
                    onClicked:
                    {
                        fncSendCommand("key right");
                    }
                    Image
                    {
                        anchors.verticalCenter: parent.verticalCenter
                        source: "image://theme/icon-m-right"
                    }
                }
                Button
                {
                    width: parent.width/3;
                    text: qsTr("Back")
                    onClicked:
                    {
                        fncSendCommand("key escape");
                    }
                    Image
                    {
                        anchors.verticalCenter: parent.verticalCenter
                        source: "image://theme/icon-m-enter"
                    }
                }
                Button
                {
                    width: parent.width/3;
                    text: ""
                    onClicked:
                    {
                        fncSendCommand("key down");
                    }
                    Image
                    {
                        anchors.verticalCenter: parent.verticalCenter
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
