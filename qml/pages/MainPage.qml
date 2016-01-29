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
    id: id_page_mainpage
    allowedOrientations: Orientation.All

    property bool bStartMainPage: true

    onStatusChanged:
    {
        if (status == PageStatus.Active && bStartMainPage)
        {
            bStartMainPage = false

            //Load settings
            var sHostname = id_CppTools.sLoadProjectData("HostName");
            var sPortnumber = id_CppTools.sLoadProjectData("PortNumber");

            if (sHostname.length > 0)
                id_TextField_HostName.text = sHostname;
            if (sPortnumber.length > 0)
                id_TextField_PortNumber.text = sPortnumber;
        }
    }

    Timer
    {
        id: timMainLoopTimer
        interval: 1000
        running: false
        repeat: true
        onTriggered:
        {
            console.log("Timer running in MainPage.qml");
        }
    }
    Timer
    {
        id: timErrorTimer
        interval: 10000
        running: false
        repeat: false
        onTriggered:
        {
            idRectangleShowError.visible = false
        }
    }


    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: id_Column_FirstCol.height + idRectangleShowError.height + id_Column_SecondCol.height + Theme.paddingLarge

        VerticalScrollDecorator {}

        PullDownMenu
        {
            MenuItem
            {
                text: "About"
                onClicked: {pageStack.push(Qt.resolvedUrl("AboutPage.qml"))}
            }            
        }
        PushUpMenu
        {
            MenuItem
            {
                id: id_menu_connect
                text: "Connect to MythTV"
                onClicked:
                {
                    idRectangleShowError.visible = false;

                    var status = id_CppTools.iConnect(id_TextField_HostName.text, id_TextField_PortNumber.text)
                    if (status == 0)
                    {
                        //Save connect settings to project settings
                        id_CppTools.vSaveProjectData("HostName", id_TextField_HostName.text);
                        id_CppTools.vSaveProjectData("PortNumber", id_TextField_PortNumber.text);

                        pageStack.pushAttached(Qt.resolvedUrl("NavigationPage.qml"));
                        pageStack.navigateForward();
                        timMainLoopTimer.start();
                    }
                    else
                    {
                        idRectangleShowError.visible = true;
                        idLabelErrorText.text = "Error while connecting to MythTV: " + status.toString();
                        timErrorTimer.start();
                    }
                }
            }
            MenuItem
            {
                id: id_menu_wol
                text: "Wakeup TV station"
                onClicked:
                {
                    //Save connect settings to project settings

                    if (id_CppTools.bSendMagicPacket(id_TextField_MacAddress.text) == false)
                    {
                        idRectangleShowError.visible = true;
                        idLabelErrorText.text = "Error while sending wake up packet!"
                        timErrorTimer.start();
                    }
                }
            }
        }

        Column
        {
            id: id_Column_FirstCol

            spacing: Theme.paddingSmall
            width: parent.width

            PageHeader { title: "Welcome to MythFish" }

            Rectangle
            {
                id: idRectangleShowError
                width: parent.width
                height: id_TextField_PortNumber.height
                color: Theme.highlightColor
                opacity: 0.5
                visible: false
                Label
                {
                    id: idLabelErrorText
                    x: Theme.paddingMedium
                    font.pixelSize: Theme.fontSizeMedium
                    anchors.centerIn: parent
                    color: "red"
                    text: "Error ..."
                }
            }
            Label
            {
                x: Theme.paddingLarge
                text: "Connection settings"
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeExtraLarge
            }
            TextField
            {
                anchors.margins: Theme.paddingLarge
                id: id_TextField_HostName
                inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
                label: "Enter host name or ip address"
                validator: RegExpValidator { regExp: /^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$/ }
                color: errorHighlight? "red" : Theme.primaryColor
                placeholderText: "Enter host name or ip address"
                onErrorHighlightChanged: errorHighlight? id_menu_connect.enabled=false : id_menu_connect.enabled=true
                text: "192.168.0.4"
                width: parent.width
            }

            TextField
            {
                anchors.margins: Theme.paddingSmall
                id: id_TextField_PortNumber
                inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoPredictiveText
                validator: RegExpValidator { regExp: /^(6553[0-5])|(655[0-2]\d)|(65[0-4]\d{2})|(6[0-4]\d{3})|([1-5]\d{4})|([1-9]\d{1,3})|(\d)$/ }
                color: errorHighlight? "red" : Theme.primaryColor
                placeholderText: "Enter port number"
                label: "Enter port number"
                onErrorHighlightChanged: errorHighlight? id_menu_connect.enabled=false : id_menu_connect.enabled=true
                text: "6546"
                width: parent.width
            }
            TextSwitch
            {
                text: "Auto Connect"
                description: "Connect on startup of this app."
                onCheckedChanged: { busy = true; timBusyTimerConnect.start() }
                Timer
                {
                    id: timBusyTimerConnect
                    interval: 1000
                    onTriggered: parent.busy = false
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

            Label
            {
                x: Theme.paddingLarge
                text: "Wake on lan settings"
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeExtraLarge
            }
            TextField
            {
                anchors.margins: Theme.paddingLarge
                id: id_TextField_MacAddress
                placeholderText: "Enter mac address"
                validator: RegExpValidator { regExp: /^((([0-9A-Fa-f]{2}[:-]){5})|(([0-9A-Fa-f]{2}){5}))([0-9A-Fa-f]{2})$/ }
                color: errorHighlight? "red" : Theme.primaryColor
                label: "Enter mac address"
                text: "00:87:34:1d:8d:f4"
                inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase
                width: parent.width
                onErrorHighlightChanged: errorHighlight? id_menu_wol.enabled=false : id_menu_wol.enabled=true
            }
            TextSwitch
            {
                text: "Auto Wakeup"
                description: "Wakeup TV station on startup of this app."
                onCheckedChanged: { busy = true; timBusyTimerWOL.start() }
                Timer
                {
                    id: timBusyTimerWOL
                    interval: 2000
                    onTriggered: parent.busy = false
                }
            }
        }
    }
}
