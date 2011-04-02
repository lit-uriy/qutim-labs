QT       += core gui webkit
TARGET = tmp
TEMPLATE = app

SOURCES += main.cpp \
    Form.cpp \
    qtwin.cpp \
    qtdwm.cpp
HEADERS += \
    Form.h \
    qtwin.h \
    qtdwm_p.h \
    qtdwm.h
FORMS += \
    Form.ui
LIBS += -lgdi32

#CONFIG += console

RESOURCES += \
    icons.qrc
