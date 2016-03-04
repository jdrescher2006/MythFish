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

Rectangle
{
    clip: true
    width: parent.width
    height: marqueeText.height
    color: "transparent"
    property string text
    property int interval : 100
    property bool bRunning: false;
    property int iWaitBeforeStart: 50;
    property int iLoopBeforeStart: 0;
    Text
    {
        anchors.verticalCenter: parent.verticalCenter
        id: marqueeText
        text: parent.text
        x: 0        //start position
        color: Theme.secondaryHighlightColor
        onTextChanged:
        {
            x = 0;
            bRunning = false;
            iLoopBeforeStart = 0;
        }
    }
    Timer
    {
        interval: parent.interval
        onTriggered: moveMarquee()
        running: true
        repeat: true
    }
    function moveMarquee()
    {
        //Check if we have to marquee at all
        if (marqueeText.width <= parent.width)
        {
            marqueeText.x = 0;
            bRunning = false;
            return;
        }
        //If this is the first time, wait here before start with marquee
        if (!bRunning)
        {
            if (iLoopBeforeStart < iWaitBeforeStart)
            {
                iLoopBeforeStart++;
                return;
            }
            else
            {
                iLoopBeforeStart = 0;
                bRunning = true;
            }
        }
        if(marqueeText.x + marqueeText.width < 0)
        {
            marqueeText.x = marqueeText.parent.width;
        }
        marqueeText.x -= 10;
    }
}
