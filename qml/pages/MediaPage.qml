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

    Timer
    {
        id: timMainLoop
        interval: 1000
        running: false
        repeat: true
        onTriggered:
        {
            if (bSoundPressed)
                return;

            var sLocation = remote.send_command("query location");
            var sVolume = remote.send_command("query volume");

            //Analyse answer.
            //Detect running playback of anything
            var iIndex = sLocation.indexOf("Playback");
            //Check if pause

            if (iIndex != -1 )
            {
                idSLDPlaySlider.visible = true;
                idSLDVolumeSlider.visible = true;

                console.log("sVolume", sVolume);

                var iVolume = parseInt(sVolume);
                if (iVolume != idSLDVolumeSlider.value)
                    idSLDVolumeSlider.value = iVolume;

                //Get play location in recording
                var sPlayLocation = sLocation.substring((sLocation.indexOf(":") - 2), (sLocation.indexOf(" ", iIndex + 18)));


                console.log("sLocation", sLocation);
                console.log("sPlayLocation", sPlayLocation);

                //Get max length of recording
                var sMaxLength = sLocation.substring((sLocation.indexOf("von", iIndex) + 4), (sLocation.indexOf(" ", (sLocation.indexOf("von", iIndex) + 4))));

                console.log("sMaxLength", sMaxLength);

                idSLDPlaySlider.valueText = sPlayLocation;

                var sPlayLocation = sPlayLocation.split(":");
                var sMaxLength = sMaxLength.split(":");

                var iPlaySeconds = 0;
                if (sPlayLocation.length == 2)
                    iPlaySeconds = (parseInt(sPlayLocation[0]) * 60) + parseInt(sPlayLocation[1]);
                else
                    iPlaySeconds = (parseInt(sPlayLocation[0]) * 3600) + (parseInt(sPlayLocation[1]) * 60) + parseInt(sPlayLocation[2]);

                var iLengthSeconds = 0;
                if (sMaxLength.length == 2)
                    iLengthSeconds = (parseInt(sMaxLength[0]) * 60) + parseInt(sMaxLength[1]);
                else
                    iLengthSeconds = (parseInt(sMaxLength[0]) * 3600) + (parseInt(sMaxLength[1]) * 60) + parseInt(sMaxLength[2]);

                idSLDPlaySlider.maximumValue = iLengthSeconds;
                idSLDPlaySlider.minimumValue = 0;
                idSLDPlaySlider.value = iPlaySeconds;

                //Paused?
                if (sLocation.indexOf("pause") == -1)
                    idSLDPlaySlider.label = "Play"
                else
                    idSLDPlaySlider.label = "Pause"
            }
            else
            {
                idSLDPlaySlider.visible = false;
                idSLDVolumeSlider.visible = false;
            }
        }
    }

    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: column.height

        Column
        {
            id: column
            width: parent.width
            spacing: Theme.paddingSmall

            PageHeader { title: "Media" }

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
                        remote.send_command("key i");
                    }
                    Image
                    {
                        source: "image://theme/icon-m-about"
                    }
                }
                Button
                {
                    width: parent.width/3;
                    text: ""
                    onClicked:
                    {
                        remote.send_command("key up");
                    }
                    Image
                    {
                        source: "image://theme/icon-m-up"
                    }
                }
                Button
                {
                    width: parent.width/3;
                    text: "Guide"
                    onClicked:
                    {
                        remote.send_command("key s");
                    }
                    Image
                    {
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
                    text: ""
                    onClicked:
                    {
                        remote.send_command("key left");
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
                        remote.send_command("key enter");
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
                        remote.send_command("key right");
                    }
                    Image
                    {
                        source: "image://theme/icon-m-right"
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
                    text: "Exit"
                    onClicked:
                    {
                        remote.send_command("key back");
                    }
                    Image
                    {
                        source: "image://theme/icon-m-backspace"
                    }
                }
                Button
                {
                    width: parent.width/3;
                    text: ""
                    onClicked:
                    {
                        remote.send_command("key down");
                    }
                    Image
                    {
                        source: "image://theme/icon-m-down"
                    }
                }
                Button
                {
                    width: parent.width/3;
                    text: "Menü"
                    onClicked:
                    {
                        remote.send_command("key m");
                    }
                    Image
                    {
                        source: "image://theme/icon-m-menu"
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
                    text: "Kanal -"
                    onClicked:
                    {
                        remote.send_command("play channel down");
                    }
                    Image
                    {
                        source: "image://theme/icon-m-page-down"
                    }
                }
                Button
                {
                    width: parent.width/3;
                    text: ""
                }
                Button
                {
                    width: parent.width/3;
                    text: "Kanal +"
                    onClicked:
                    {
                        remote.send_command("play channel up");
                    }
                    Image
                    {
                        source: "image://theme/icon-m-page-up"
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
                    text: "Leiser"
                    onClicked:
                    {
                        remote.send_command("key [");
                    }
                    Image
                    {
                        source: "../icon-m-quiet.png"
                    }
                }
                Button
                {
                    width: parent.width/3;
                    text: "Stumm"
                    onClicked:
                    {
                        remote.send_command("key |");
                    }
                    Image
                    {
                        source: "image://theme/icon-m-speaker-mute"
                    }
                }
                Button
                {
                    width: parent.width/3;
                    text: "Lauter"
                    onClicked:
                    {
                        remote.send_command("key ]");
                    }
                    Image
                    {
                        source: "image://theme/icon-m-speaker"
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
                    text: "Rec"
                    onClicked:
                    {
                        remote.send_command("key r");
                    }
                    Image
                    {
                        source: "image://theme/icon-m-dot"
                    }
                }
                Button
                {
                    width: parent.width/4;
                    text: "Stop"
                    onClicked:
                    {
                        remote.send_command("key stop");
                    }
                    Image
                    {
                        source: "../icon-m-stop.png"
                    }
                }
                Button
                {
                    width: parent.width/4;
                    text: "Pause"
                    onClicked:
                    {
                        remote.send_command("play speed pause");
                    }
                    Image
                    {
                        source: "image://theme/icon-m-pause"
                    }
                }
                Button
                {
                    width: parent.width/4;
                    text: "Play"
                    onClicked:
                    {
                        remote.send_command("play speed normal");
                    }
                    Image
                    {
                        source: "image://theme/icon-m-play"
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
            }
            Row
            {
                width: parent.width
                Image
                {
                    source: "../icon-m-quiet.png"
                }
                Slider
                {
                    id: idSLDVolumeSlider
                    value: 0
                    minimumValue: 0
                    maximumValue: 100
                    enabled: true
                    width: parent.width/1.5
                    handleVisible: true
                    valueText : ""
                    label: "Volume"
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
                        remote.send_command("play volume " + Math.ceil(idSLDVolumeSlider.value) + "%");
                        bSoundPressed = false;
                    }
                }
                Image
                {
                    source: "image://theme/icon-m-speaker"
                }
            }
        }
    }
}
