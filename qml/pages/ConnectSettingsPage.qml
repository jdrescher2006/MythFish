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
            spacing: Theme.paddingSmall
            width: parent.width
            PageHeader { title: qsTr("Connect to MythTV") }

            Label
            {
                x: Theme.paddingLarge
                text: qsTr("Connection settings")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeExtraLarge
            }
            TextField
            {
                anchors.margins: Theme.paddingLarge
                id: id_TextField_HostName
                inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
                label: qsTr("Enter host name or ip address")
                validator: RegExpValidator { regExp: /^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$/ }
                color: errorHighlight? "red" : Theme.primaryColor
                placeholderText: qsTr("Enter host name or ip address")
                text: sHostname
                width: parent.width
                onAcceptableInputChanged:
                {
                    sHostname = id_TextField_HostName.text;
                    id_ProjectSettings.vSaveProjectData("HostName", id_TextField_HostName.text);
                }
            }
            TextField
            {
                anchors.margins: Theme.paddingSmall
                id: id_TextField_PortNumber
                inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoPredictiveText
                validator: RegExpValidator { regExp: /^(6553[0-5])|(655[0-2]\d)|(65[0-4]\d{2})|(6[0-4]\d{3})|([1-5]\d{4})|([1-9]\d{1,3})|(\d)$/ }
                color: errorHighlight? "red" : Theme.primaryColor
                placeholderText: qsTr("Enter port number")
                label: qsTr("Enter port number")
                text: sPortnumber
                width: parent.width
                onTextChanged:
                {
                    sPortnumber = id_TextField_PortNumber.text;
                    id_ProjectSettings.vSaveProjectData("PortNumber", id_TextField_PortNumber.text);
                }
            }
            TextSwitch
            {
                id: id_TextSwitch_AutoConnect
                text: qsTr("Auto Connect")
                description: qsTr("Connect on startup of this app.")
                checked: bAutoWakeup
                onCheckedChanged:
                {
                    busy = true;
                    timBusyTimerConnect.start();
                    bAutoWakeup = checked;
                    id_ProjectSettings.vSaveProjectData("AutoConnect", checked.toString());
                }
                Timer
                {
                    id: timBusyTimerConnect
                    interval: 1000
                    onTriggered: parent.busy = false
                }
            }
        }
    }
}

