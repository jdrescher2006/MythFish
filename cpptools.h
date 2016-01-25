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

#ifndef CPPTOOLS
#define CPPTOOLS

#include <QObject>
#include <QTcpSocket>

class Cpptools : public QObject {
    Q_OBJECT
    QTcpSocket *tcpSocket;
    Q_PROPERTY(QString host READ sGetHostname)
    Q_PROPERTY(QString port READ sGetPortnumber)
public:
    QString strHostname;
    QString strPortnumber;
    bool bConnected;
    explicit Cpptools(QObject *parent = 0);

    Q_INVOKABLE int iConnect(QString strGetHostname, QString strGetPortnumber);
    Q_INVOKABLE QString sSendCommand(QString strGetCommand);
    Q_INVOKABLE int iDisconnect();

    Q_INVOKABLE bool bGetConnected();
    Q_INVOKABLE QString sGetHostname();
    Q_INVOKABLE QString sGetPortnumber();

signals:

public slots:

};

#endif // CPPTOOLS

