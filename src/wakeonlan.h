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

#ifndef WAKEONLAN
#define WAKEONLAN

#include <QObject>
#include <QUdpSocket>

class WakeOnLan : public QObject
{
    Q_OBJECT
public:
    explicit WakeOnLan(QObject *parent = 0);
    Q_INVOKABLE qint64 iSendMagicPacket(QString sMacAddress);
    Q_INVOKABLE bool bIsValidMacAddress(QString sMacAddress);
private:
    QUdpSocket *udpSocket;
    QString sCleanMac(QString sMacAddress);
};

#endif // WAKEONLAN
