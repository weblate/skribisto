QT += testlib
QT -= gui

CONFIG += qt console warn_on depend_includepath testcase
CONFIG -= app_bundle

TEMPLATE = app

# add data lib :

win32: LIBS += -L$$OUT_PWD/../../../src/ -lskribisto-data
else:unix: LIBS += -L$$OUT_PWD/../../../src/ -lskribisto-data

INCLUDEPATH += $$PWD/../../../src
DEPENDPATH += $$PWD/../../../src



SOURCES += \
    tst_writecase.cpp


RESOURCES += \
    ../../../../../resources/test/testfiles.qrc
