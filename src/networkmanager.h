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

#ifndef NETWORKMANAGER
#define NETWORKMANAGER

#include <QObject>
class QNetworkConfigurationManager;

class NetworkManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool online READ online NOTIFY onlineChanged)
public:
    explicit NetworkManager(QObject *parent = 0);
    ~NetworkManager();
    bool online() const { return _online; }
signals:
    void onlineChanged(bool online);
protected slots:
    void onOnlineStateChanged(bool isOnline);
private:
    QNetworkConfigurationManager *_manager;
    bool _online;
};

#endif // NETWORKMANAGER

