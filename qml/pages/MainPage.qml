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

            var sGetHostname = id_ProjectSettings.sLoadProjectData("HostName");
            var sGetPortnumber = id_ProjectSettings.sLoadProjectData("PortNumber");
            var bGetAutoConnect = (id_ProjectSettings.sLoadProjectData("AutoConnect")  === "true");
            var sGetMACaddress = id_ProjectSettings.sLoadProjectData("MACaddress");
            var bGetAutoWakeup = (id_ProjectSettings.sLoadProjectData("AutoWakeup") === "true");

            console.log("sGetHostname: " + sGetHostname);
            console.log("sGetPortnumber: " + sGetPortnumber);
            console.log("bGetAutoConnect: " + bGetAutoConnect);
            console.log("sGetMACaddress: " + sGetMACaddress.toString());
            console.log("bGetAutoWakeup: " + bGetAutoWakeup.toString());

            //Default values for very first start of app
            if (sHostname.length < 1) sHostname="192.168.0.4"
            if (sPortnumber.length < 1) sPortnumber="6546"
            if (sMACaddress.length < 1) sMACaddress="00:87:34:1d:8d:f4"

            console.log("sHostname: " + sHostname);
            console.log("sPortnumber: " + sPortnumber);
            console.log("sMACaddress: " + sMACaddress);

            //If wake on lan then do it here
            if (bAutoWakeup)
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
            if (bAutoConnect)
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
                text: qsTr("Connect to MythTV")
                visible: !bConnected
                onClicked:
                {
                    idRectangleShowError.visible = false;

                    var sReturn = id_MythRemote.sConnect(sHostname, sPortnumber);
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
                Image
                {
                   source: "image://theme/icon-m-transfer"
                }
            }
            Button
            {
                width: parent.width
                text: qsTr("Disconnect from MythTV")
                visible: bConnected
                onClicked:
                {
                    id_MythRemote.vDisconnect();
                    bConnected = false;
                    pageStack.popAttached(undefined, PageStackAction.Immediate);
                }
                Image
                {
                   source: "image://theme/icon-m-reset"
                }
            }
            Button
            {
                width: parent.width
                text: qsTr("Wakeup TV station")
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
                Image
                {
                    source: "../icon-m-tv.png"
                }
            }
        }       
    }
}
