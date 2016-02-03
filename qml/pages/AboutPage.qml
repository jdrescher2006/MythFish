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

    Column
    {
        anchors.top: parent.top
        width: parent.width

        PageHeader
        {
            title: "About MythFish"
        }
        Item
        {
            width: parent.width
            height: Theme.paddingMedium
        }
        Image
        {
            anchors.horizontalCenter: parent.horizontalCenter
            height: 256
            fillMode: Image.PreserveAspectFit
            source: "../MythSailMote.png"
        }
        Label
        {
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: Theme.fontSizeLarge
            horizontalAlignment: Text.AlignHCenter
            text: "MythFish"
        }
        Item
        {
            width: parent.width
            height: Theme.paddingMedium
        }
        Label
        {
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: Theme.fontSizeExtraSmall
            wrapMode: Text.WordWrap
            maximumLineCount: 2
            horizontalAlignment: Text.AlignHCenter
            text: "MythTV remote control application for Sailfish OS"
        }
        Item
        {
            width: parent.width
            height: Theme.paddingLarge
        }
        Label
        {
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: Theme.fontSizeExtraSmall
            color: Theme.secondaryColor
            text: "Copyright \u00A9 2016 Jens Drescher"
        }
        Label
        {
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: Theme.fontSizeExtraSmall
            color: Theme.secondaryColor
            text: "Version: 1.00"
        }
        Label
        {
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: Theme.fontSizeExtraSmall
            color: Theme.secondaryColor
            text: "Date: 01.02.2016"
        }
        Label
        {
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: Theme.fontSizeExtraSmall
            color: Theme.secondaryColor
            text: "License: GPLv3"
        }
        Item
        {
            width: parent.width
            height: Theme.paddingLarge
        }
        Label
        {
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: Theme.fontSizeExtraSmall
            color: Theme.secondaryColor
            text: "Source code:"
        }
        Label
        {
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: Theme.fontSizeExtraSmall
            property string urlstring: "https://github.com/jdrescher2006/MythSailMote"
            text: "<a href=\"" + urlstring + "\">" +  urlstring + "<\a>"
            onLinkActivated: Qt.openUrlExternally(link)
        }
    }
}

