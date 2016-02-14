TARGET = MythFish

CONFIG += sailfishapp

SOURCES += src/MythFish.cpp \
    src/wakeonlan.cpp \
    src/projectsettings.cpp \
    src/mythremote.cpp

OTHER_FILES += qml/MythFish.qml \
    qml/cover/CoverPage.qml \
    rpm/MythFish.changes.in \
    rpm/MythFish.spec \
    rpm/MythFish.yaml \
    translations/*.ts \
    MythFish.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256

CONFIG += sailfishapp_i18n

TRANSLATIONS += translations/MythFish-de.ts

HEADERS += \
    src/wakeonlan.h \
    src/projectsettings.h \
    src/mythremote.h

DISTFILES += \
    qml/MythFish.png \
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
    qml/pages/ConnectSettingsPage.qml

