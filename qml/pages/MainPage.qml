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

Dialog
{
    id: id_page_mainpage
    onAccepted:
    {
        idRectangleShowError.visible = false;

        var status = id_CppTools.iConnect(id_TextField_HostName.text, id_TextField_PortNumber.text)
        if (status == 0)
        {
            pageStack.pushAttached(Qt.resolvedUrl("NavigationPage.qml"));
            pageStack.navigateForward();
            timMainLoopTimer.start();
        }
        else
        {
            idRectangleShowError.visible = true;
            idLabelErrorText.text = "Error while connecting to MythTV: " + status.toString();
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


    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: column.height

        Column
        {
            id: column

            spacing: Theme.paddingLarge
            width: parent.width

            DialogHeader
            {
                title: "MythSailMote"
            }

            Label
            {
                x: Theme.paddingLarge
                text: qsTr("Start by connecting\r\nto a frontend")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeExtraLarge
            }

            TextField
            {
                anchors.margins: Theme.paddingLarge
                id: id_TextField_HostName
                inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
                label: "Enter host name or ip address"
                placeholderText: "Enter host name or ip"
                text: "192.168.0.4"
                width: parent.width
            }

            TextField
            {
                anchors.margins: Theme.paddingLarge
                id: id_TextField_PortNumber
                inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoPredictiveText
                placeholderText: "Enter port"
                label: "Port"
                text: "6546"
                width: parent.width
            }
            Rectangle
            {
                id: idRectangleShowError
                anchors.top: parent.bottom;
                anchors.left: parent.left;
                anchors.right: parent.right;
                height: id_TextField_PortNumber.height;
                color: Theme.highlightColor;
                opacity: 0.5
                visible: false;
                Label
                {
                    id: idLabelErrorText
                    anchors.centerIn: parent
                    text: "Error ..."
                }
            }
        }
    }
}
