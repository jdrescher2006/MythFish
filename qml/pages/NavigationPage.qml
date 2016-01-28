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
    id: id_page_navpage
    allowedOrientations: Orientation.All
    property bool bPushMediaPage: true

    onStatusChanged:
    {
        if (status == PageStatus.Active && bPushMediaPage)
        {
            console.log("SecondPage: pushAttach of MediaPage!!!");
            bPushMediaPage = false
            pageStack.pushAttached(Qt.resolvedUrl("MediaPage.qml"));
        }
    }

    SilicaFlickable
    {
        anchors.fill: parent                

        VerticalScrollDecorator {}
        Column
        {
            id: id_column_jumpcolumn
            width: parent.width
            spacing: Theme.paddingSmall
            PageHeader { title: "Navigation" }

            Row
            {
                spacing: Theme.paddingSmall
                width: parent.width

                Button
                {
                    width: parent.width/3
                    text: "Home"
                    onClicked:
                    {
                        id_CppTools.sSendCommand("jump mainmenu");
                    }
                    Image
                    {
                        width: 32;
                        height: 32;
                        source: "image://theme/icon-m-home"
                    }
                }
                Button
                {
                    width: parent.width/3
                    text: "Live TV"
                    onClicked:
                    {
                        id_CppTools.sSendCommand("jump livetv");
                    }
                    Image
                    {
                        width: 32;
                        height: 32;
                        source: "../icon-m-tv.png"
                    }
                }
                Button
                {
                    width: parent.width/3
                    text: "Recordings"
                    onClicked:
                    {
                        id_CppTools.sSendCommand("jump playbackrecordings");
                    }
                    Image
                    {
                        width: 32;
                        height: 32;
                        source: "../icon-m-rec.png"
                    }
                }
            }
            Row
            {
                spacing: Theme.paddingSmall
                width: parent.width

                Button
                {
                    width: parent.width/3
                    text: "Music"
                    onClicked:
                    {
                        id_CppTools.sSendCommand("jump playmusic");
                    }
                    Image
                    {
                        width: 32;
                        height: 32;
                        source: "image://theme/icon-m-music"
                    }
                }
                Button
                {
                    width: parent.width/3
                    text: "Videos"
                    onClicked:
                    {
                        id_CppTools.sSendCommand("jump mythvideo");
                    }
                    Image
                    {
                        width: 32;
                        height: 32;
                        source: "image://theme/icon-m-video"
                    }
                }
                Button
                {
                    width: parent.width/3
                    text: "Status"
                    onClicked:
                    {
                        id_CppTools.sSendCommand("jump statusbox");
                    }
                    Image
                    {
                        width: 32;
                        height: 32;
                        source: "image://theme/icon-m-question";
                    }
                }
            }
            Row
            {
                spacing: Theme.paddingSmall
                width: parent.width

                Button
                {
                    width: parent.width/3
                    text: "Guide"
                    onClicked:
                    {
                        id_CppTools.sSendCommand("jump guidegrid");
                    }
                    Image
                    {
                        width: 32;
                        height: 32;
                        source: "image://theme/icon-m-events"
                    }
                }
            }
        }

        Column
        {
            id: id_column_arrowscolumn
            anchors.top: id_column_jumpcolumn.bottom;
            width: parent.width
            spacing: Theme.paddingSmall
            anchors.topMargin: 30;

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
