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

    ListModel
    {
        id: id_ListModel_SettingsPages

        ListElement
        {
            page: "WOLSettingsPage.qml"
            title: "Wake on LAN"
            subtitle: "Licht Schalten"
            section: "Main"
        }
        ListElement
        {
            page: "ConnectSettingsPage.qml"
            title: "Connect to MythTV"
            subtitle: "Heizung Übersicht"
            section: "Main"
        }
    }
    SilicaListView
    {
        id: listView
        anchors.fill: parent
        model: id_ListModel_SettingsPages
        header: PageHeader { title: qsTr("Settings") }
        section {
            property: 'section'
            delegate: SectionHeader
            {
                text: section
            }
        }
        delegate: BackgroundItem
        {
            width: listView.width
            Label
            {
                id: firstName
                text: model.title
                color: highlighted ? Theme.highlightColor : Theme.primaryColor
                anchors.verticalCenter: parent.verticalCenter
                x: Theme.horizontalPageMargin
            }
            onClicked: pageStack.push(Qt.resolvedUrl(page))
        }
        VerticalScrollDecorator {}
    }
}

