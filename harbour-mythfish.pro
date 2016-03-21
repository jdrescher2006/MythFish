TARGET = harbour-mythfish

CONFIG += sailfishapp

SOURCES += \
    src/wakeonlan.cpp \
    src/projectsettings.cpp \
    src/mythremote.cpp \
    src/harbour-mythfish.cpp \
    src/networkmanager.cpp

OTHER_FILES += qml/harbour-mythfish.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-mythfish.yaml \
    rpm/harbour-mythfish.spec \
    harbour-mythfish.desktop \
    translations/*.ts

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256

CONFIG += sailfishapp_i18n

TRANSLATIONS += translations/harbour-mythfish-de.ts

HEADERS += \
    src/wakeonlan.h \
    src/projectsettings.h \
    src/mythremote.h \
    src/networkmanager.h

DISTFILES += \
    qml/icon-m-tv.png \
    qml/icon-m-stop.png \
    qml/icon-m-rec.png \
    qml/icon-m-quiet.png \
    qml/pages/AboutPage.qml \
    qml/pages/SettingsPage.qml \
    qml/pages/MainPage.qml \
    qml/pages/WOLSettingsPage.qml \
    qml/pages/NumbersPage.qml \
    qml/pages/NavigationPage.qml \
    qml/pages/MediaPage.qml \
    qml/pages/ConnectSettingsPage.qml \
    qml/icon-m-cloud.png \
    qml/pages/PlayingPage.qml \    
    qml/MythFish.png \
    qml/tools/Marquee.qml \
    rpm/harbour-mythfish.changes

