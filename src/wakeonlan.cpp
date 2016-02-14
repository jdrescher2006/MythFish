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

#include "wakeonlan.h"
#include <QtGui>

WakeOnLan::WakeOnLan(QObject *parent) : QObject(parent)
{
    this->udpSocket = new QUdpSocket(this);
}

//WOL functions
bool WakeOnLan::bIsValidMacAddress(QString sMacAddress)
{
    QRegExp r("^([0-9a-f]{2}([:-]|$)){6}$", Qt::CaseInsensitive);
    return r.exactMatch(sMacAddress);
}

qint64 WakeOnLan::iSendMagicPacket(QString sMacAddress)
{
    QByteArray macDest = this->sCleanMac(sMacAddress).toLocal8Bit();

    QByteArray magicSequence = QByteArray::fromHex("ffffffffffff");
    for (int i=0; i<16; i++)
        magicSequence.append(QByteArray::fromHex(macDest));

    qint64 byteCount = this->udpSocket->writeDatagram(magicSequence.data(), magicSequence.size(), QHostAddress::Broadcast, 40000);

    return byteCount;   //If error, byteCount should be -1!!!
}

QString WakeOnLan::sCleanMac(QString sMacAddress)
{
    return sMacAddress.replace(QRegExp("[:-]", Qt::CaseInsensitive), "");
}
