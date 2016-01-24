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
                        remote.send_command("jump mainmenu");
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
                        remote.send_command("jump livetv");
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
                        remote.send_command("jump playbackrecordings");
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
                        remote.send_command("jump playmusic");
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
                        remote.send_command("jump mythvideo");
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
                        remote.send_command("jump statusbox");
                    }
                    Image
                    {
                        width: 32;
                        height: 32;
                        source: "image://theme/icon-m-question";
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
                        remote.send_command("key up");
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
                        source: "../icon-m-stop.png"
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
                Button
                {
                    width: parent.width/3;
                    text: "Back"
                    onClicked:
                    {
                        remote.send_command("key escape");
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
                    visible: false;
                }
            }
        }
    }
}





