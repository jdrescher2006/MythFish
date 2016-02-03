TARGET = MythSailMote

CONFIG += sailfishapp

SOURCES += src/MythSailMote.cpp \
    src/wakeonlan.cpp \
    src/mythremote.cpp \
    src/projectsettings.cpp

OTHER_FILES += qml/MythSailMote.qml \
    qml/cover/CoverPage.qml \
    rpm/MythSailMote.changes.in \
    rpm/MythSailMote.spec \
    rpm/MythSailMote.yaml \
    translations/*.ts \
    MythSailMote.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/MythSailMote-de.ts

DISTFILES += \
    qml/pages/MainPage.qml \
    qml/pages/NavigationPage.qml \
    qml/pages/NumbersPage.qml \
    qml/pages/MediaPage.qml \
    qml/icon-m-quiet.png \
    qml/icon-m-stop.png \
    qml/icon-m-tv.png \
    qml/icon-m-rec.png \
    qml/pages/AboutPage.qml \
    qml/MythSailMote.png \
    qml/pages/SettingsPage.qml \
    qml/pages/ConnectSettingsPage.qml \
    qml/pages/WOLSettingsPage.qml

HEADERS += \
    src/wakeonlan.h \
    src/mythremote.h \
    src/projectsettings.h

