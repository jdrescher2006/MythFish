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

CoverBackground
{
    Image
    {
        anchors.margins: Theme.paddingMedium
        anchors.top: parent.top
        anchors.bottom: id_label_AppName.top
        anchors.left: parent.left
        anchors.right: parent.right
        fillMode: Image.PreserveAspectFit
        source: "../MythFish.png"
    }
    Label
    {
        id: id_label_AppName
        anchors.centerIn: parent
        text: "MythFish"
    }
    Label
    {
        id: id_label_AppStatus        
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: id_label_AppName.bottom
        text: sCurrentLocation===""? sCoverPageStatusText : sCurrentLocation
        font { family: Theme.fontFamily; pixelSize: Theme.fontSizeTiny }
    }
    Label
    {
        id: id_label_Title
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width - Theme.paddingMedium
        anchors.top: id_label_AppStatus.bottom
        text: sPlayingTitle
        truncationMode: TruncationMode.Elide
        font { family: Theme.fontFamily; pixelSize: Theme.fontSizeTiny }
    }

    CoverActionList
    {
        id: coverAction

        CoverAction
        {
            iconSource: "image://theme/icon-cover-pause"
            onTriggered:
            {
                if (bConnected)
                    fncSendCommand("play speed pause");
            }
        }

        CoverAction
        {
            iconSource: "image://theme/icon-cover-play"
            onTriggered:
            {
                if (bConnected)
                    fncSendCommand("play speed normal");
            }
        }
    }
}
