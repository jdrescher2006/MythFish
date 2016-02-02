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

        VerticalScrollDecorator {}

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
                        id_MythRemote.sSendCommand("key r");
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
                        id_MythRemote.sSendCommand("key stop");
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
                        id_MythRemote.sSendCommand("play speed pause");
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
                        id_MythRemote.sSendCommand("play speed normal");
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
                        id_MythRemote.sSendCommand("play seek backward");
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
                        id_MythRemote.sSendCommand("key left");
                    }
                }
                Button
                {
                    width: parent.width/4;
                    text: "FF"
                    onClicked:
                    {                        
                        id_MythRemote.sSendCommand("key right");
                    }
                }
                Button
                {
                    width: parent.width/4;
                    text: "Next"
                    onClicked:
                    {
                        id_MythRemote.sSendCommand("play seek forward");
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
                        id_MythRemote.sSendCommand("key i");
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
                        id_MythRemote.sSendCommand("key m");
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
                        id_MythRemote.sSendCommand("key s");
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
                        id_MythRemote.sSendCommand("key [");
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
                        id_MythRemote.sSendCommand("key |");
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
                        id_MythRemote.sSendCommand("key ]");
                    }
                    Image
                    {
                        width: 32;
                        height: 32;
                        source: "image://theme/icon-m-speaker"
                    }
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
                        id_MythRemote.sSendCommand("key up");
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
                        id_MythRemote.sSendCommand("key left");
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
                        id_MythRemote.sSendCommand("key enter");
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
                        id_MythRemote.sSendCommand("key right");
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
                        id_MythRemote.sSendCommand("key escape");
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
                        id_MythRemote.sSendCommand("key down");
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
