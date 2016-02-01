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
    property bool bInitPage: true

    onStatusChanged:
    {
        if (status == PageStatus.Active && bStartMainPage)
        {
            bInitPage = true;
            bStartMainPage = false;

            //Load settings
            var sHostname = id_ProjectSettings.sLoadProjectData("HostName");
            var sPortnumber = id_ProjectSettings.sLoadProjectData("PortNumber");
            var sAutoConnect = id_ProjectSettings.sLoadProjectData("AutoConnect");
            var sMACaddress = id_ProjectSettings.sLoadProjectData("MACaddress");
            var sAutoWakeup = id_ProjectSettings.sLoadProjectData("AutoWakeup");

            if (sHostname.length > 0)
                id_TextField_HostName.text = sHostname;
            if (sPortnumber.length > 0)
                id_TextField_PortNumber.text = sPortnumber;
            if (sAutoConnect.length > 0)
                id_TextSwitch_AutoConnect.checked = (sAutoConnect === "true");
            if (sMACaddress.length > 0)
                id_TextField_MacAddress.text = sMACaddress;
            if (sAutoWakeup.length > 0)
                id_TextSwitch_AutoWakeup.checked = (sAutoWakeup === "true");

            //If wake on lan then do it here
            if (sAutoWakeup === "true")
            {
                idRectangleShowError.visible = false;

                var iReturnByteCount = id_WakeOnLan.iSendMagicPacket(sMACaddress);

                console.log("iReturnByteCount: " + iReturnByteCount.toString());

                if (iReturnByteCount == -1)
                {
                    idRectangleShowError.visible = true;
                    idLabelErrorText.text = qsTr("Error while sending wake up packet!");
                    timErrorTimer.start();
                }
            }

            //If wake on lan then do it here
            if (sAutoConnect === "true")
            {
                idRectangleShowError.visible = false;

                var status = id_MythRemote.iConnect(sHostname, sPortnumber)
                if (status == 0)
                {
                    pageStack.pushAttached(Qt.resolvedUrl("NavigationPage.qml"));
                    pageStack.navigateForward();
                }
                else
                {
                    idRectangleShowError.visible = true;
                    if (status == 1)
                        idLabelErrorText.text = qsTr("The connection was refused by the peer (or timed out).");
                    if (status == 2)
                        idLabelErrorText.text = qsTr("Could not connect, is this really MythTV?");

                    timErrorTimer.start();
                }
            }

            bInitPage = false;
        }
    }  

    Timer
    {
        id: timMainLoopTimer
        interval: 2000
        running: true
        repeat: true
        onTriggered:
        {
            //Don't do anything when page is initialising
            if (bInitPage)
                return;
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

                    var status = id_MythRemote.iConnect(id_TextField_HostName.text, id_TextField_PortNumber.text);
                    if (status == 0)
                    {
                        pageStack.pushAttached(Qt.resolvedUrl("NavigationPage.qml"));
                        pageStack.navigateForward();
                    }
                    else
                    {
                        idRectangleShowError.visible = true;
                        if (status == 1)
                            idLabelErrorText.text = qsTr("The connection was refused by the peer (or timed out).");
                        if (status == 2)
                            idLabelErrorText.text = qsTr("Could not connect, is this really MythTV?");

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
                    idRectangleShowError.visible = false;

                    if (id_WakeOnLan.bSendMagicPacket(id_TextField_MacAddress.text) == false)
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
                    x: Theme.paddingSmall
                    font.pixelSize: Theme.fontSizeSmall
                    anchors.centerIn: parent
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
                onAcceptableInputChanged:
                {
                    if (!bInitPage)
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
                placeholderText: "Enter port number"
                label: "Enter port number"
                onErrorHighlightChanged: errorHighlight? id_menu_connect.enabled=false : id_menu_connect.enabled=true
                text: "6546"
                width: parent.width
                onTextChanged:
                {
                    console.log("onAcceptableInputChanged");
                    if (!bInitPage)
                    {
                        console.log("vSaveProjectData: " + id_TextField_PortNumber.text);
                        id_ProjectSettings.vSaveProjectData("PortNumber", id_TextField_PortNumber.text);
                    }
                }
            }
            TextSwitch
            {
                id: id_TextSwitch_AutoConnect
                text: "Auto Connect"
                description: "Connect on startup of this app."
                onCheckedChanged:
                {
                    busy = true;
                    timBusyTimerConnect.start();
                    if (!bInitPage)
                        id_ProjectSettings.vSaveProjectData("AutoConnect", id_TextSwitch_AutoConnect.checked.toString());
                }
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
                onAcceptableInputChanged:
                {
                    if (!bInitPage)
                        id_ProjectSettings.vSaveProjectData("MACaddress", id_TextField_MacAddress.text);
                }
            }
            TextSwitch
            {
                id: id_TextSwitch_AutoWakeup
                text: "Auto Wakeup"
                description: "Wakeup TV station on startup of this app."
                onCheckedChanged:
                {
                    busy = true;
                    timBusyTimerWOL.start();
                    if (!bInitPage)
                        id_ProjectSettings.vSaveProjectData("AutoWakeup", id_TextSwitch_AutoWakeup.checked.toString());
                }
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
