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
#include <QUdpSocket>
#include <QRegExp>
#include <QRegExpValidator>

class Cpptools : public QObject {
    Q_OBJECT
    QTcpSocket *tcpSocket;
    Q_PROPERTY(QString host READ sGetHostname)
    Q_PROPERTY(QString port READ sGetPortnumber)
public:
    //Remote
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

    //WOL
    Q_INVOKABLE QString sGetError();
    Q_INVOKABLE bool bSendMagicPacket(QString sMacAddress);
    Q_INVOKABLE bool bIsValidMacAddress(QString sMacAddress);

    //Load/save
    Q_INVOKABLE void vSaveProjectData(const QString &sKey, const QString &sValue);
    Q_INVOKABLE QString sLoadProjectData(const QString &sKey);
private:
    //WOL
    QUdpSocket *udpSocket;
    QString sCleanMac(QString sMacAddress);
    QString sError;
};

#endif // CPPTOOLS

