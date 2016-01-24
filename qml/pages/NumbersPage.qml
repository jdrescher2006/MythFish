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
    id: id_page_numberspage
    allowedOrientations: Orientation.All

    SilicaFlickable
    {
        anchors.fill: parent
        VerticalScrollDecorator {}

        Column
        {
            id: id_column_maincolumn
            width: parent.width
            height: parent.height;
            spacing: Theme.paddingSmall
            PageHeader { title: "Numbers" }

            Grid
            {
                columns: 3;
                rows: 4;
                width: parent.width;
                height: 100;
                spacing: Theme.paddingSmall;

                Button
                {
                    width: parent.width/3
                    height: parent.height/4
                    text: "1"
                    onClicked:
                    {
                        //remote.send_command("key 1");
                    }
                }
                Button
                {
                    width: parent.width/3
                    height: parent.height/4
                    text: "2"
                    onClicked:
                    {
                        //remote.send_command("key 2");
                    }
                }
                Button
                {
                    width: parent.width/3
                    height: parent.height/4
                    text: "3"
                    onClicked:
                    {
                        //remote.send_command("key 3");
                    }
                }
                Button
                {
                    width: parent.width/3
                    height: parent.height/4
                    text: "4"
                    onClicked:
                    {
                       // remote.send_command("key 4");
                    }
                }
                Button
                {
                    width: parent.width/3
                    height: parent.height/4
                    text: "5"
                    onClicked:
                    {
                        //remote.send_command("key 5");
                    }
                }
                Button
                {
                    width: parent.width/3
                    height: parent.height/4
                    text: "6"
                    onClicked:
                    {
                        //remote.send_command("key 6");
                    }
                }
                Button
                {
                    width: parent.width/3
                    height: parent.height/4
                    text: "7"
                    onClicked:
                    {
                        //remote.send_command("key 7");
                    }
                }
                Button
                {
                    width: parent.width/3
                    height: parent.height/4
                    text: "8"
                    onClicked:
                    {
                        //remote.send_command("key 8");
                    }
                }
                Button
                {
                    width: parent.width/3
                    height: parent.height/4
                    text: "9"
                    onClicked:
                    {
                        //remote.send_command("key 9");
                    }
                }
                Button
                {
                    width: parent.width/3
                    height: parent.height/4
                    text: "Delete"
                    onClicked:
                    {
                        //remote.send_command("key delete");
                    }
                }
                Button
                {
                    width: parent.width/3
                    height: parent.height/4
                    text: "0"
                    onClicked:
                    {
                        //remote.send_command("key 0");
                    }
                }
                Button
                {
                    width: parent.width/3
                    height: parent.height/4
                    text: "Enter"
                    onClicked:
                    {
                        //remote.send_command("key return");
                    }
                }
            }
        }
    }
}
