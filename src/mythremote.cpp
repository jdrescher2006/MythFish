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

#include "mythremote.h"
#include <QtGui>

MythRemote::MythRemote(QObject *parent) : QObject(parent)
{
    this->tcpSocket = new QTcpSocket(this);
    this->bConnected = false;
}

QString MythRemote::sConnect(QString strGetHostname, QString strGetPortnumber)
{
    this->strHostname = strGetHostname;
    this->strPortnumber = strGetPortnumber;
    if (this->bConnected)
        disconnect();
    this->tcpSocket->connectToHost(this->strHostname, this->strPortnumber.toInt());

    if (this->tcpSocket->waitForConnected(1000) == false)
    {
        QString sError = this->tcpSocket->errorString();
        //qDebug() << "Host: " << strGetHostname << ", Port: " << strGetPortnumber << ", Error: " << sError;
        return sError;
    }

    this->tcpSocket->waitForReadyRead(1000);
    QString sReturnValue;
    while (this->tcpSocket->bytesAvailable())
    {
        sReturnValue.append(QString(this->tcpSocket->read(128)));
    }

    if (!sReturnValue.contains("MythFrontend Network Control"))
    {
        this->vDisconnect();

        return "Error: Wrong machine!";
    }
    this->bConnected = true;
    return "OK";
}

QString MythRemote::sSendCommand(QString strGetCommand)
{
    //Check if socket is connected.
    //ACHTUNG: Es gibt auch ein Signal. Besser das verwenden!!!

    /*
    MythRemote::sSendCommand:81 - SendCommand, error:  "Unknown error"
   [D] MythRemote::sSendCommand:63 - QAbstractSocket::ConnectedState
   [D] MythRemote::sSendCommand:81 - SendCommand, error:  "Unknown error"
   [D] MythRemote::sSendCommand:63 - QAbstractSocket::ConnectedState
   [D] MythRemote::sSendCommand:81 - SendCommand, error:  "Unknown error"
   [D] MythRemote::sSendCommand:63 - QAbstractSocket::ConnectedState
   [D] MythRemote::sSendCommand:81 - SendCommand, error:  "Unknown error"
   [D] MythRemote::sSendCommand:63 - QAbstractSocket::UnconnectedState
   [D] MythRemote::sSendCommand:81 - SendCommand, error:  "Socket is not connected"
    */

    qDebug() << this->tcpSocket->state();

    if (!this->tcpSocket->state() == QAbstractSocket::ConnectedState)
    {
        this->vDisconnect();
        return "ERROR: disconnect!";        //If this error is given back, the qml part has to disconnect
    }

    strGetCommand.append("\n");
    this->tcpSocket->write(strGetCommand.toLatin1());
    this->tcpSocket-> waitForReadyRead(1000);
    QString sReturnValue;
    while (this->tcpSocket->bytesAvailable())
    {
        sReturnValue.append(QString(this->tcpSocket->read(128)));
    }

    QString sError = this->tcpSocket->errorString();
    qDebug() << "SendCommand, error: " << sError;

    if (tcpSocket->error() == QAbstractSocket::RemoteHostClosedError)
    {
        this->vDisconnect();
        return "ERROR: disconnect!";        //If this error is given back, the qml part has to disconnect
    }

    return sReturnValue;
}

void MythRemote::vDisconnect()
{
    this->tcpSocket->disconnectFromHost();
    this->tcpSocket->abort();
    if (this->bConnected)
    {
        this->bConnected = false;
    }    
}

bool MythRemote::bGetConnected()
{
    return this->bConnected;
}

QString MythRemote::sGetHostname()
{
    return this->strHostname;
}

QString MythRemote::sGetPortnumber()
{
    return this->strPortnumber;
}
