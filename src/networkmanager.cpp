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

#include "networkmanager.h"
#include <QtGui>
#include <QNetworkConfigurationManager>

NetworkManager::NetworkManager(QObject *parent)
    : QObject(parent)
    , _manager(new QNetworkConfigurationManager(parent))
    , _online(_manager->isOnline() && _manager->defaultConfiguration().isValid())
{
    connect(_manager, SIGNAL(onlineStateChanged(bool)),
            this, SLOT(onOnlineStateChanged(bool)));
}

NetworkManager::~NetworkManager()
{
    delete _manager;
}

void NetworkManager::onOnlineStateChanged(bool isOnline)
{
    if (isOnline != _online) {
        qDebug() << "Network is " << (isOnline ? "online" : "offline");
        _online = isOnline;
        emit onlineChanged(_online);
    }
}
