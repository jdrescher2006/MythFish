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

                var sReturn = id_MythRemote.sConnect(id_TextField_HostName.text, id_TextField_PortNumber.text);
                if (sReturn == "OK")
                {
                    bConnected = true;
                    pageStack.pushAttached(Qt.resolvedUrl("NavigationPage.qml"));
                    pageStack.navigateForward();
                }
                else
                {
                    idRectangleShowError.visible = true;

                    //Check for specific error message
                    if (sReturn === "Error: Wrong machine!")
                        sReturn = qsTr("Could not connect, is this really MythTV?")

                    idLabelErrorText.text = sReturn;
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

            if (!id_TextSwitch_PollServer.checked)
                return;

            //Are we connected to frontend?
            if (!id_MythRemote.bGetConnected())
                return;

            //First read current location
            var sLocation = id_MythRemote.sSendCommand("query location");

            //possible locations:
            //mainmenu, guidegrid, StatusBox, mythvideo, playlistview(Music), playbackbox(Recordings)

            console.log("Location: " + sLocation);

            //Extract what MythTV is currently doing
            var iIndex = "unknown"
            iIndex = sLocation.indexOf("Playback");     //playback of any media
            if (iIndex == -1 )
                bMythPlayback = false;
            else
                bMythPlayback = true;

            if (!bMythPlayback)
                return;

            var sVolume = id_MythRemote.sSendCommand("query volume");

            console.log("Volume: " + sVolume);

            iVolumePercent = parseInt(sVolume);
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
        contentHeight: id_Column_Main.height + idRectangleShowError.height

        VerticalScrollDecorator {}

        PullDownMenu
        {
            MenuItem
            {
                text: qsTr("Settings")
                onClicked: {pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))}
            }
            MenuItem
            {
                text: qsTr("About")
                onClicked: {pageStack.push(Qt.resolvedUrl("AboutPage.qml"))}
            }            
        }
        PushUpMenu
        {           
            MenuItem
            {
                id: id_menu_connect
                text: "Connect to MythTV"
                visible: !bConnected
                onClicked:
                {
                    idRectangleShowError.visible = false;

                    var sReturn = id_MythRemote.sConnect(id_TextField_HostName.text, id_TextField_PortNumber.text);
                    if (sReturn == "OK")
                    {
                        bConnected = true;
                        pageStack.pushAttached(Qt.resolvedUrl("NavigationPage.qml"));
                        pageStack.navigateForward();
                    }
                    else
                    {
                        idRectangleShowError.visible = true;

                        //Check for specific error message
                        if (sReturn === "Error: Wrong machine!")
                            sReturn = qsTr("Could not connect, is this really MythTV?")

                        idLabelErrorText.text = sReturn;
                        timErrorTimer.start();
                    }
                }
            }
            MenuItem
            {
                id: id_menu_disconnect
                text: "Disconnect from MythTV"
                visible: bConnected
                onClicked:
                {
                    id_MythRemote.vDisconnect();
                    bConnected = false;
                    pageStack.popAttached(undefined, PageStackAction.Immediate);
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
            id: id_Column_Main

            spacing: Theme.paddingLarge
            width: parent.width

            PageHeader { title: "Welcome to MythFish" }

            Rectangle
            {
                id: idRectangleShowError
                width: parent.width
                height: Theme.paddingLarge
                color: Theme.highlightColor
                opacity: 0.5
                visible: false
                Label
                {
                    id: idLabelErrorText
                    x: Theme.paddingSmall
                    width: parent.width
                    wrapMode: Text.WordWrap
                    font.pixelSize: Theme.fontSizeSmall
                    anchors.centerIn: parent
                    text: "Error ..."
                }
            }
            Button
            {
                width: parent.width
                text: "Connect to MythTV"
                onClicked:
                {

                }
                Image
                {
                   source: "image://theme/icon-m-transfer"
                }
            }
            Button
            {
                width: parent.width
                text: "Wakeup TV station"
                onClicked:
                {

                }
                Image
                {
                    source: "../icon-m-tv.png"
                }
            }

            TextSwitch
            {
                id: id_TextSwitch_PollServer
                text: "Poll"
                description: "Poll server."
            }
        }       
    }
}
