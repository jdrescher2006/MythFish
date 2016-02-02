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
        qDebug() << "Host: " << strGetHostname << ", Port: " << strGetPortnumber << ", Error: " << sError;
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
    strGetCommand.append("\n");
    this->tcpSocket->write(strGetCommand.toLatin1());
    this->tcpSocket-> waitForReadyRead(1000);
    QString sReturnValue;
    while (this->tcpSocket->bytesAvailable())
    {
        sReturnValue.append(QString(this->tcpSocket->read(128)));
    }

    QString sError = this->tcpSocket->errorString();
    qDebug() << "Send error: " << sError;

    if (sError.length() > 0)    //an error occured so break here and return error message.
    {
        this->vDisconnect();
        QString sReturn = "Error: ";
        sReturn.append(sError);

        return sReturn;
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
