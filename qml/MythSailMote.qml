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
import "pages"
import wakeonlan 1.0
import mythremote 1.0
import projectsettings 1.0

ApplicationWindow
{       
    property bool bMythPlayback: false;
    property int iVolumePercent: 0;
    property bool bConnected: false;

    property string sHostname: "192.168.0.4";
    property string sPortnumber: "6546";
    property bool bAutoConnect: false;
    property string sMACaddress: "00:19:99:3b:15:f7";
    property bool bAutoWakeup: false;

    WakeOnLan{ id: id_WakeOnLan }
    MythRemote{ id: id_MythRemote }
    ProjectSettings{ id: id_ProjectSettings }

    initialPage: Component { MainPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: Orientation.All
    _defaultPageOrientations: Orientation.All
}


