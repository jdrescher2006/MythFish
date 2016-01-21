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


Page {
    id: page

    property bool bPushNumbersPage: true

    onStatusChanged:
    {
        if (status == PageStatus.Active && bPushNumbersPage)
        {
            console.log("SecondPage: pushAttach of NumbersPage!!!");
            bPushNumbersPage = false
            pageStack.pushAttached(Qt.resolvedUrl("NumbersPage.qml"));
        }
    }

    SilicaListView {
        id: listView
        model: 3
        anchors.fill: parent
        header: PageHeader {
            title: "Media"
        }
        delegate: BackgroundItem {
            id: delegate

            Label {
                x: Theme.paddingLarge
                text: qsTr("Item") + " " + index
                anchors.verticalCenter: parent.verticalCenter
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
            }
            onClicked: console.log("Clicked " + index)
        }
        VerticalScrollDecorator {}
    }
}





