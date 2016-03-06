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
    property bool bAutoConnecting: false    

    function fncGetValue(sKey, sMessage)
    {
        var sReturn = "";
        sKey = "<Key>" + sKey + "</Key><Value>";

        sReturn = sMessage.substring((sMessage.indexOf(sKey) + sKey.length));

        sKey = "</Value>";
        sReturn = sReturn.substring(0, sReturn.indexOf(sKey));
        sReturn = sReturn.trim();

        return sReturn;
    }

    Connections     //amazing trick...
    {
        target: id_MythRemote
        onVDisconnected:
        {
            fncViewMessage("info", qsTr("Closed connection to MythTV!"));

            sCoverPageStatusText = qsTr("Not connected");

            bConnected = false;
            pageStack.popAttached(undefined, PageStackAction.Immediate);            
        }
    }  

    onStatusChanged:
    {
        if (status === PageStatus.Active && bStartMainPage)
        {
            bInitPage = true;
            bStartMainPage = false;
            sCoverPageStatusText = qsTr("Initializing...");

            //Load project data
            var sGetHostname = id_ProjectSettings.sLoadProjectData("HostName");
            var sGetPortnumber = id_ProjectSettings.sLoadProjectData("PortNumber");
            var bGetAutoConnect = id_ProjectSettings.sLoadProjectData("AutoConnect");
            var sGetMACaddress = id_ProjectSettings.sLoadProjectData("MACaddress");
            var bGetAutoWakeup = id_ProjectSettings.sLoadProjectData("AutoWakeup");

            /*
            console.log("sGetHostname: " + sGetHostname);
            console.log("sGetPortnumber: " + sGetPortnumber);
            console.log("bGetAutoConnect: " + bGetAutoConnect);
            console.log("sGetMACaddress: " + sGetMACaddress);
            console.log("bGetAutoWakeup: " + bGetAutoWakeup);
            */

            //If there is something in the project data, use it.
            if (sGetHostname.length > 0) sHostname=sGetHostname;
            if (sGetPortnumber.length > 0) sPortnumber=sGetPortnumber;
            if (bGetAutoConnect.length > 0) bAutoConnect=(bGetAutoConnect === "true");
            if (sGetMACaddress.length > 0) sMACaddress=sGetMACaddress;
            if (bGetAutoWakeup.length > 0) bAutoWakeup=(bGetAutoWakeup === "true");

            /*
            console.log("sHostname: " + sHostname);
            console.log("sPortnumber: " + sPortnumber);
            console.log("bAutoConnect: " + bAutoConnect.toString());
            console.log("sMACaddress: " + sMACaddress);
            console.log("bAutoWakeup: " + bAutoWakeup.toString());
            */

            //If wake on lan then do it here
            if (bAutoWakeup)
            {
                sCoverPageStatusText = qsTr("Waking up TV station...");

                var iReturnByteCount = id_WakeOnLan.iSendMagicPacket(sMACaddress);

                //console.log("iReturnByteCount: " + iReturnByteCount.toString());

                if (iReturnByteCount === -1)
                {
                    fncViewMessage("error", qsTr("Error while sending wake up packet!"));
                }
            }

            //If wake on lan then do it here
            if (bAutoConnect)
            {                
                bAutoConnecting = true;
                timConnectLoopTimer.start();
            }

            sCoverPageStatusText = qsTr("Not connected");

            bInitPage = false;
        }
    }  

    Timer
    {
        id: timConnectLoopTimer
        interval: 3000
        running: false
        repeat: true
        onTriggered:
        {
            sCoverPageStatusText = qsTr("Conecting to MythTV...");

            var sReturn = id_MythRemote.sConnect(sHostname, sPortnumber);
            if (sReturn === "OK")
            {
                bAutoConnecting = false;
                timConnectLoopTimer.stop();
                bConnected = true;                
                sCoverPageStatusText = qsTr("Connected");
                fncViewMessage("info", sCoverPageStatusText);
                pageStack.pushAttached(Qt.resolvedUrl("NavigationPage.qml"));
                pageStack.navigateForward();
            }
            else
            {
                //Check for specific error message
                if (sReturn === "Error: Wrong machine!")
                    sReturn = qsTr("Could not connect, is this really MythTV?")

                fncViewMessage("error", sReturn);
            }
        }
    }
    Timer
    {
        id: timQueryMythTVTimerHTTP
        interval: 2000
        running: (bConnected && !bSoundPressed && !bPlaybackPressed)
        repeat: true
        onTriggered:
        {
            if (!bConnected || bSoundPressed || bPlaybackPressed)
                return;

            fncGetMythData(function(message)
            {                
                if (message === "Error")
                {
                    return;
                }

                //First, search for state
                var sState = fncGetValue("state", message);

                //console.log("sState: " + sState);

                if (sState === "idle")
                {
                    bPlaybackActice = false;

                    //In idle state, we have to find out what is going on
                    var sLocationString = fncGetValue("currentlocation", message);

                    //console.log("sLocationString: " + sLocationString);

                    if (sLocationString === "mythgallery")
                        sCurrentLocation = qsTr("Pictures");
                    else if (sLocationString === "mainmenu")
                        sCurrentLocation = qsTr("Main menu");
                    else if (sLocationString === "guidegrid")
                        sCurrentLocation = qsTr("Guide");
                    else if (sLocationString === "StatusBox")
                        sCurrentLocation = qsTr("Status");
                    else if (sLocationString === "mythvideo")
                        sCurrentLocation = qsTr("Videos");
                    else if (sLocationString === "playlistview")
                        sCurrentLocation = qsTr("Music");
                    else if (sLocationString === "playbackbox")
                        sCurrentLocation = qsTr("Recordings");
                }
                else if(sState === "WatchingVideo")
                {
                    bPlaybackActice = true;
                    sCurrentLocation = qsTr("Play Video");
                }
                else if(sState === "WatchingLiveTV")
                {
                    bPlaybackActice = true;
                    sCurrentLocation = qsTr("Play live TV");
                }
                else if(sState === "WatchingPreRecorded" || sState === "WatchingRecording")
                {
                    bPlaybackActice = true;
                    sCurrentLocation = qsTr("Play recording");
                }
                else
                {
                    bPlaybackActice = true;
                    sCurrentLocation = sState;
                }

                if (!bPlaybackActice)
                {
                    sCurrentPlayPosition = "";
                    iCurrentPlayPosition = 0;
                    iMaxPlayPosition = 100;
                    sPlayingState = "";
                    sPlayingTitle = "";
                    //TODO: pop the playing page
                    //pageStack.pop(undefined);

                    return;
                }

                //Get Volume
                iVolumePercent = parseInt(fncGetValue("volume", message));

                //Get title
                sPlayingTitle = fncGetValue("title", message);

                //console.log("sPlayingTitle: " + sPlayingTitle);

                //Get playback position
                sCurrentPlayPosition = fncGetValue("relplayedtime", message);

                 //console.log("sCurrentPlayPosition: " + sCurrentPlayPosition);

                //Get playback length as seconds, int
                iMaxPlayPosition = parseInt(fncGetValue("reltotalseconds", message));

                //console.log("iMaxPlayPosition: " + iMaxPlayPosition);

                //Get playback position as seconds, int
                iCurrentPlayPosition = parseInt(fncGetValue("relsecondsplayed", message));

                //console.log("iCurrentPlayPosition: " + iCurrentPlayPosition);

                //Get if pause
                if (fncGetValue("playspeed", message) === "0")
                    sPlayingState = "Pause";
                else
                    sPlayingState = "Play";
            })
        }
    }
    Timer
    {
        //ATTENTION: this code (the complete timer) is inactive.
        //It is not used any more but is conserved for future uses.
        //There are problems with the control socket of MythTV.
        //I often have timeouts when querying data. MythTV even gets unstable sometimes.
        //So I use the other timer, which retrieves the data via the HTTP frontend service.
        //Other advantage of HTTP is that I get more data from it, such as the title.

        id: timQueryMythTVTimer
        interval: 1000
        //running: (bConnected && !bSoundPressed)
        running: false;
        repeat: true
        onTriggered:
        {
            if (!bConnected || bSoundPressed)
                return;

            //Read current location of MythTV
            var sLocation = id_MythRemote.sSendCommand("query location");
            var sVolume = id_MythRemote.sSendCommand("query volume");

            console.log("Location: " + sLocation);
            console.log("Volume: " + sVolume);

            //parse volume
            iVolumePercent = parseInt(sVolume);

            //Check if playback is active
            if (sLocation.indexOf("Playback ") !== "-1")
                bPlaybackActice = true;
            else
                bPlaybackActice = false;

            //possible locations:
            //mainmenu, guidegrid, StatusBox, mythvideo, playlistview (Music), playbackbox (Recordings), OK
            if (sLocation.indexOf("mainmenu") !== "-1")
                sCurrentLocation = qsTr("Main menu");
            else if (sLocation.indexOf("guidegrid") !== "-1")
                sCurrentLocation = qsTr("Guide");
            else if (sLocation.indexOf("StatusBox") !== "-1")
                sCurrentLocation = qsTr("Status");
            else if (sLocation.indexOf("mythvideo") !== "-1")
                sCurrentLocation = qsTr("Videos");
            else if (sLocation.indexOf("playlistview") !== "-1")
                sCurrentLocation = qsTr("Music");
            else if (sLocation.indexOf("playbackbox") !== "-1")
                sCurrentLocation = qsTr("Recordings");
            else if (sLocation.indexOf("Playback Recorded") !== "-1")
                sCurrentLocation = qsTr("Play recording");
            else if (sLocation.indexOf("Playback LiveTV") !== "-1")
                sCurrentLocation = qsTr("Play live TV");
            else if (sLocation.indexOf("mythgallery") !== "-1")
                sCurrentLocation = qsTr("Pictures");
            else
                sCurrentLocation = "";

            if (!bPlaybackActice)
            {
                sCurrentPlayPosition = "";
                iCurrentPlayPosition = 0;
                iMaxPlayPosition = 100;
                sPlayingState = "";

                return;
            }

            //Get play location in recording
            //Search first colon in the first block
            var sFromPosString = sLocation.substring(sLocation.lastIndexOf(" ",sLocation.indexOf(":")), sLocation.indexOf(" ",sLocation.indexOf(":")));
            sFromPosString = sFromPosString.trim();
            sCurrentPlayPosition = sFromPosString;
            console.log("sFromPosString: " + sFromPosString);

            var sToPosString = sLocation.substring((sLocation.indexOf(sFromPosString) + sFromPosString.length));
            sToPosString = sToPosString.substring(sToPosString.lastIndexOf(" ",sToPosString.indexOf(":")), sToPosString.indexOf(" ",sToPosString.indexOf(":")));            
            console.log("sToPosString: " + sToPosString);

            var sPlayLocation = sFromPosString.split(":");
            var sMaxLength = sToPosString.split(":");

            var iPlaySeconds = 0;
            if (sPlayLocation.length === 2)
                iPlaySeconds = (parseInt(sPlayLocation[0]) * 60) + parseInt(sPlayLocation[1]);
            else
                iPlaySeconds = (parseInt(sPlayLocation[0]) * 3600) + (parseInt(sPlayLocation[1]) * 60) + parseInt(sPlayLocation[2]);

            var iLengthSeconds = 0;
            if (sMaxLength.length === 2)
                iLengthSeconds = (parseInt(sMaxLength[0]) * 60) + parseInt(sMaxLength[1]);
            else
                iLengthSeconds = (parseInt(sMaxLength[0]) * 3600) + (parseInt(sMaxLength[1]) * 60) + parseInt(sMaxLength[2]);

            iMaxPlayPosition = iLengthSeconds;
            iCurrentPlayPosition = iPlaySeconds;

            if (sLocation.indexOf("pause") === -1)
                sPlayingState = "Play";
            else
                sPlayingState = "Pause";
        }
    }

    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: id_Column_Main.height

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

        Column
        {
            id: id_Column_Main

            spacing: Theme.paddingLarge
            width: parent.width

            PageHeader { title: qsTr("Welcome to MythFish") }           

            SectionHeader
            {
                text: qsTr("Connecting to MythTV...")
                visible: bAutoConnecting
            }
            Button
            {
                width: parent.width
                text: qsTr("Cancel")
                visible: bAutoConnecting
                onClicked:
                {
                    timConnectLoopTimer.stop();
                    bAutoConnecting = false;
                    sCoverPageStatusText = qsTr("Not connected");
                }
                Image
                {
                    source: "image://theme/icon-m-sync"
                    anchors.verticalCenter: parent.verticalCenter
                    smooth: true
                    NumberAnimation on rotation
                    {                     
                      from: 0
                      to: 360
                      loops: Animation.Infinite
                      duration: 2000
                    }
                }
            }

            SectionHeader
            {
                text: qsTr("Connect to MythTV")
                visible: (!bConnected && !bAutoConnecting)
            }
            Button
            {
                width: parent.width
                text: qsTr("Connect")
                visible: (!bConnected && !bAutoConnecting)
                onClicked:
                {
                    var sReturn = id_MythRemote.sConnect(sHostname, sPortnumber);
                    if (sReturn == "OK")
                    {
                        bConnected = true;
                        sCoverPageStatusText = qsTr("Connected");
                        fncViewMessage("info", sCoverPageStatusText);
                        pageStack.pushAttached(Qt.resolvedUrl("NavigationPage.qml"));
                        pageStack.navigateForward();
                    }
                    else
                    {
                        //Check for specific error message
                        if (sReturn === "Error: Wrong machine!")
                            sReturn = qsTr("Could not connect, is this really MythTV?")
                        else
                            sReturn = qsTr("Error: ") + sReturn;

                        fncViewMessage("error", sReturn);
                    }
                }
                Image
                {
                    anchors.verticalCenter: parent.verticalCenter
                    source: "image://theme/icon-m-transfer"
                }
            }

            SectionHeader
            {
                text: qsTr("Disconnect from MythTV")
                visible: bConnected
            }
            Button
            {
                width: parent.width
                text: qsTr("Disconnect")
                visible: bConnected
                onClicked:
                {
                    id_MythRemote.vDisconnect();                   
                }
                Image
                {
                    anchors.verticalCenter: parent.verticalCenter
                    source: "image://theme/icon-m-reset"
                }
            }

            SectionHeader
            {
                text: qsTr("Wake up TV station")
            }
            Button
            {
                width: parent.width
                text: qsTr("Wake up")
                onClicked:
                {
                    var iReturnByteCount = id_WakeOnLan.iSendMagicPacket(sMACaddress);

                    //console.log("iReturnByteCount: " + iReturnByteCount.toString());

                    if (iReturnByteCount == -1)
                    {
                        fncViewMessage("error", qsTr("Error while sending wake up packet!"));
                    }
                }
                Image
                {
                    anchors.verticalCenter: parent.verticalCenter
                    source: "../icon-m-tv.png"
                }
            }
        }       
    }
}
