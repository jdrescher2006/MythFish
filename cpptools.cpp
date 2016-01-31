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

#include "cpptools.h"
#include <QTcpSocket>
#include <QtGui>

Cpptools::Cpptools(QObject *parent) : QObject(parent)
{
    this->tcpSocket = new QTcpSocket(this);
    this->bConnected = false;
    this->udpSocket = new QUdpSocket(this);
}

//Remote functions
int Cpptools::iConnect(QString strGetHostname, QString strGetPortnumber)
{
    this->strHostname = strGetHostname;
    this->strPortnumber = strGetPortnumber;
    if (this->bConnected)
        disconnect();
    this->tcpSocket->connectToHost(this->strHostname, this->strPortnumber.toInt());
    this->tcpSocket->waitForConnected(1000);
    if (this->tcpSocket->error() == QAbstractSocket::ConnectionRefusedError)
    {
        //qDebug() << "Connection refused\n";
        return -1; // If can't connect
    }

    this->tcpSocket->waitForReadyRead(1000);
    QString sReturnValue;
    while (this->tcpSocket->bytesAvailable())
    {
        sReturnValue.append(QString(this->tcpSocket->read(128)));
    }
    //qDebug() << "Connected\n" << ret_val;

    if (!sReturnValue.contains("MythFrontend Network Control"))
    {
        //qDebug() << "Wrong server\nServer returned: " << ret_val;
        this->iDisconnect();
        return -2; // If it's not mythfrontend
    }
    this->bConnected = true;
    return 0;
}

QString Cpptools::sSendCommand(QString strGetCommand)
{
    strGetCommand.append("\n");
    this->tcpSocket->write(strGetCommand.toLatin1());
    this->tcpSocket-> waitForReadyRead(1000);
    QString sReturnValue;
    while (this->tcpSocket->bytesAvailable())
    {
        sReturnValue.append(QString(this->tcpSocket->read(128)));
    }
    //qDebug() << "Command:" << command << ret_val;
    if (this->tcpSocket->error() == QAbstractSocket::RemoteHostClosedError)
    {
        this->iDisconnect();
        return "Error: RemoteHostClosed"; // If frontend is closed
    }
    return sReturnValue;
}

int Cpptools::iDisconnect()
{
    this->tcpSocket->disconnectFromHost();
    this->tcpSocket->abort();
    if (this->bConnected)
    {
        this->bConnected = false;
    }
    //qDebug() << "Disconnected";
    return 0;
}

bool Cpptools::bGetConnected()
{
    return this->bConnected;
}

QString Cpptools::sGetHostname()
{
    return this->strHostname;
}

QString Cpptools::sGetPortnumber()
{
    return this->strPortnumber;
}

//WOL functions
bool Cpptools::bIsValidMacAddress(QString sMacAddress)
{
    QRegExp r("^([0-9a-f]{2}([:-]|$)){6}$", Qt::CaseInsensitive);
    return r.exactMatch(sMacAddress);
}

QString Cpptools::sGetError()
{
    return this->sError;
}

bool Cpptools::bSendMagicPacket(QString sMacAddress)
{
    QByteArray macDest = this->sCleanMac(sMacAddress).toLocal8Bit();

    QByteArray magicSequence = QByteArray::fromHex("ffffffffffff");
    for (int i=0; i<16; i++)
        magicSequence.append(QByteArray::fromHex(macDest));

    qint64 byteCount = this->udpSocket->writeDatagram(magicSequence.data(), magicSequence.size(), QHostAddress::Broadcast, 40000);

    if (byteCount == -1)
    {
        qDebug() << "Magisches Paket konnte nicht gesendet werden";
        this->sError = QObject::tr("Magisches Paket konnte nicht gesendet werden");
    }

    return (byteCount > -1);
}

QString Cpptools::sCleanMac(QString sMacAddress)
{
    return sMacAddress.replace(QRegExp("[:-]", Qt::CaseInsensitive), "");
}

//Save/load settings functions
void Cpptools::vSaveProjectData(const QString &sKey, const QString &sValue)
{
    QSettings settings;
    settings.setValue(sKey, sValue);

    return;
}
QString Cpptools::sLoadProjectData(const QString &sKey)
{
    QSettings settings;
    QString sMySetting = settings.value(sKey, "").toString();

    //qDebug() << sMySetting;

    return sMySetting;
}
