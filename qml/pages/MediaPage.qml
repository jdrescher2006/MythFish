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
    property bool bPushNumbersPage: true

    onStatusChanged:
    {
        if (status == PageStatus.Active && bPushNumbersPage)
        {
            //console.log("SecondPage: pushAttach of NumbersPage!!!");
            bPushNumbersPage = false
            pageStack.pushAttached(Qt.resolvedUrl("NumbersPage.qml"));
        }
    } 

    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: id_Column_FirstCol.height + Theme.paddingLarge + id_Column_SecondCol.height +
                       Theme.paddingLarge + id_Column_ThirdCol.height + Theme.paddingLarge;

        VerticalScrollDecorator {}

        PullDownMenu
        {
            visible: bPlaybackActice

            MenuItem
            {
                text: qsTr("Now Playing...")
                onClicked: {pageStack.push(Qt.resolvedUrl("PlayingPage.qml"))}
            }
        }

        Column
        {
            id: id_Column_FirstCol

            spacing: Theme.paddingSmall
            width: parent.width

            PageHeader { title: qsTr("Play Media") }

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
                        fncSendCommand("play seek backward");
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
                        fncSendCommand("key left");
                    }
                }
                Button
                {
                    width: parent.width/4;
                    text: "FF"
                    onClicked:
                    {                        
                        fncSendCommand("key right");
                    }
                }
                Button
                {
                    width: parent.width/4;
                    text: "Next"
                    onClicked:
                    {
                        fncSendCommand("play seek forward");
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
                        fncSendCommand("key [");
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
                    text: qsTr("Mute")
                    onClicked:
                    {
                        fncSendCommand("key |");
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
                        fncSendCommand("key ]");
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
