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

    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: id_Column_Main.height

        VerticalScrollDecorator {}

        Column
        {
            id: id_Column_Main

            spacing: Theme.paddingLarge
            width: parent.width

            PageHeader { title: qsTr("Settings") }

            Button
            {
                width: parent.width
                text: qsTr("MythTV Connection Settings")
                onClicked: {pageStack.push(Qt.resolvedUrl("ConnectSettingsPage.qml"))}
                Image
                {
                   source: "image://theme/icon-m-developer-mode"
                }
            }
            Button
            {
                width: parent.width
                text: qsTr("Wake On LAN Settings")
                onClicked: {pageStack.push(Qt.resolvedUrl("WOLSettingsPage.qml"))}
                Image
                {
                   source: "image://theme/icon-m-developer-mode"
                }
            }
        }
    }
}
