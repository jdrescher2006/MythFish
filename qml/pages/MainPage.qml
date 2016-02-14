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

    Connections     //amazing trick...
    {
        target: id_MythRemote
        onVDisconnected:
        {
            idRectangleShowError.visible = true;
            idLabelErrorText.text = qsTr("Closed connection to MythTV!");
            sCoverPageStatusText = qsTr("Not connected");
            timErrorTimer.start();

            bConnected = false;
            pageStack.popAttached(undefined, PageStackAction.Immediate);
        }
    }

    onStatusChanged:
    {
        if (status == PageStatus.Active && bStartMainPage)
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

                idRectangleShowError.visible = false;

                var iReturnByteCount = id_WakeOnLan.iSendMagicPacket(sMACaddress);

                //console.log("iReturnByteCount: " + iReturnByteCount.toString());

                if (iReturnByteCount == -1)
                {
                    idRectangleShowError.visible = true;
                    idLabelErrorText.text = qsTr("Error while sending wake up packet!");
                    timErrorTimer.start();
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

            idRectangleShowError.visible = false;

            var sReturn = id_MythRemote.sConnect(sHostname, sPortnumber);
            if (sReturn == "OK")
            {
                bAutoConnecting = false;
                timConnectLoopTimer.stop();
                bConnected = true;
                sCoverPageStatusText = qsTr("Connected");
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

        Column
        {
            id: id_Column_Main

            spacing: Theme.paddingLarge
            width: parent.width

            PageHeader { title: qsTr("Welcome to MythFish") }

            Rectangle
            {
                id: idRectangleShowError
                width: parent.width
                height: Theme.paddingLarge
                color: Theme.highlightColor
                visible: false
                Label
                {
                    id: idLabelErrorText
                    x: Theme.paddingSmall
                    width: parent.width
                    wrapMode: Text.WordWrap
                    color: "red";
                    font.pixelSize: Theme.fontSizeSmall
                    anchors.centerIn: parent
                    text: "Error ..."
                }
            }

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
                    idRectangleShowError.visible = false;

                    var sReturn = id_MythRemote.sConnect(sHostname, sPortnumber);
                    if (sReturn == "OK")
                    {
                        bConnected = true;
                        sCoverPageStatusText = qsTr("Connected");
                        pageStack.pushAttached(Qt.resolvedUrl("NavigationPage.qml"));
                        pageStack.navigateForward();
                    }
                    else
                    {
                        idRectangleShowError.visible = true;

                        //Check for specific error message
                        if (sReturn === "Error: Wrong machine!")
                            sReturn = qsTr("Could not connect, is this really MythTV?")
                        else
                            sReturn = qsTr("Error: ") + sReturn;

                        idLabelErrorText.text = sReturn;
                        timErrorTimer.start();
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
                    idRectangleShowError.visible = false;

                    var iReturnByteCount = id_WakeOnLan.iSendMagicPacket(sMACaddress);

                    //console.log("iReturnByteCount: " + iReturnByteCount.toString());

                    if (iReturnByteCount == -1)
                    {
                        idRectangleShowError.visible = true;
                        idLabelErrorText.text = qsTr("Error while sending wake up packet!");
                        timErrorTimer.start();
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
