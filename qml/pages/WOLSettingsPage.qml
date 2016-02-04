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

    property bool bStartWOLSettingsPage: true
    property bool bInitPage: true

    onStatusChanged:
    {
        //If dialog is started, set project values to dialog
        if (status == PageStatus.Active && bStartWOLSettingsPage)
        {
            bInitPage = true;
            bStartWOLSettingsPage = false;

            id_TextField_MacAddress.text = sMACaddress;
            id_TextSwitch_AutoWakeup.checked = bAutoWakeup;

            bInitPage = false;
        }

        //Save values to project data when page is closed
        if (status === PageStatus.Deactivating && !bInitPage)
        {
            //Check if fields are valid and have changed
            if (!id_TextField_MacAddress.errorHighlight && sMACaddress !== id_TextField_MacAddress.text)
            {
                sMACaddress = id_TextField_MacAddress.text;
                id_ProjectSettings.vSaveProjectData("MACaddress", id_TextField_MacAddress.text);
            }
            if (bAutoWakeup != id_TextSwitch_AutoWakeup.checked)
            {
                bAutoWakeup = id_TextSwitch_AutoWakeup.checked;
                id_ProjectSettings.vSaveProjectData("AutoConnect", id_TextSwitch_AutoWakeup.checked.toString());
            }
        }
    }

    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: id_Column_Main.height
        VerticalScrollDecorator {}

        Column
        {
            id: id_Column_Main
            spacing: Theme.paddingSmall
            width: parent.width

            PageHeader
            {
                title: qsTr("Wake on LAN")
            }

            Label
            {
                x: Theme.paddingLarge
                text: qsTr("Wake on lan settings")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeExtraLarge
            }
            TextField
            {
                anchors.margins: Theme.paddingLarge
                id: id_TextField_MacAddress
                placeholderText: qsTr("Enter mac address")
                validator: RegExpValidator { regExp: /^((([0-9A-Fa-f]{2}[:-]){5})|(([0-9A-Fa-f]{2}){5}))([0-9A-Fa-f]{2})$/ }
                color: errorHighlight? "red" : Theme.primaryColor
                label: qsTr("Enter mac address")
                inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase
                width: parent.width              
            }
            TextSwitch
            {
                id: id_TextSwitch_AutoWakeup
                text: qsTr("Auto Wakeup")
                description: qsTr("Wakeup TV station on startup of this app.")               
            }
        }
    }
}

