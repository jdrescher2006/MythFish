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
import org.nemomobile.notifications 1.0
import "pages"
import harbour.mythfish 1.0
//import harbour.mythfish.mythremote 1.0
//import harbour.mythfish.projectsettings 1.0
//import harbour.mythfish.networkmanager 1.0

ApplicationWindow
{
    //Define global variables
    property bool bConnected: false;
    property bool bNetworkConnected: false;
    property string sHostname: "192.168.0.4";
    property string sPortnumber: "6546";
    property string sPortnumberHTTP: "6547";
    property bool bAutoConnect: false;
    property string sMACaddress: "00:19:99:3b:15:f7";
    property bool bAutoWakeup: false;
    property string sCoverPageStatusText: "";
    property string sCurrentLocation: "";
    property int iVolumePercent: 0;
    property bool bSoundPressed: false;
    property bool bPlaybackPressed: false;
    property bool bPlaybackActice: false;
    property string sCurrentPlayPosition: "";
    property int iCurrentPlayPosition: 0;
    property int iMaxPlayPosition: 100;
    property string sPlayingState: "";
    property string sPlayingTitle: "";

    //Init C++ classes, libraries
    WakeOnLan{ id: id_WakeOnLan }
    MythRemote { id: id_MythRemote }
    ProjectSettings{ id: id_ProjectSettings }
    NetworkManager{ id: id_NetworkManager }
    Notification { id: mainPageNotification }

    //Define global functions
    function fncViewMessage(sCategory, sMessage)
    {
        mainPageNotification.category = (sCategory === "error")
            ? "x-sailfish.sailfish-utilities.error"
            : "x-sailfish.sailfish-utilities.info";
        mainPageNotification.previewBody = "MythFish";
        mainPageNotification.previewSummary = sMessage;
        mainPageNotification.close();
        mainPageNotification.publish();
    }

    function fncSendCommand(sCommand)
    {
        id_MythRemote.sSendCommand(sCommand);
    }

    function fncGetMythData(callback)
    {
        var doc = new XMLHttpRequest();
        doc.onreadystatechange = function()
        {
            if (doc.readyState == XMLHttpRequest.HEADERS_RECEIVED)
            {
                var status = doc.status;
                if(status!=200)
                {
                    callback("Error");
                }
            }
            else if (doc.readyState == XMLHttpRequest.DONE && doc.status == 200)
            {
                //var xmlResult = doc.responseXML;
                var xmlResult = doc.responseText;


                callback(xmlResult);
            }
        }

        doc.open("GET","http://" + sHostname + ":" + sPortnumberHTTP + "/Frontend/GetStatus");
        doc.send(null);
    }

    function fncTester()
    {
        /*
          Der ganze Scheiss funktioniert nicht. Ich bekomme immer einen komischen Zeiger zurück vom Find.
          Das Find ist echt scheisse...

        console.log(pageStack.find(function(page) { return "Name der Seite: " + page.objectName }));

        var bTester123 = false;

        bTester123 = pageStack.find(function(page)
        {
            if (page.objectName === "ChannelBrowser")
                return true;
            return false;
        });

        if (bTester123 !== null)
            console.log("Seite gefunden: " + bTester123.toString());

        bTester123 = pageStack.find(function(page)
        {
            if (page.objectName === "PlayingPage")
                return true;
            return false;
        });

        if (bTester123 !== null)
            console.log("Seite gefunden: " + bTester123.toString());


        pageStack.pop(pageStack.find(function(page)
        {
            return page.toString() === "Page_QMLTYPE_25(0x497e6300, \"PlayingPage\")";
        }),PageStackAction.Immediate);
        */
    }

    initialPage: Component { MainPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: Orientation.All
    _defaultPageOrientations: Orientation.All
}
