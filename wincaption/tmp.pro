QT       += core gui
TARGET = tmp
TEMPLATE = app

SOURCES += main.cpp \
    Form.cpp \
    qtwin.cpp \
    qtdwm.cpp \
	toolframewindow.cpp

HEADERS += \
    Form.h \
    qtwin.h \
    qtdwm_p.h \
    qtdwm.h \
    toolframewindow.h \
	toolframewindow_p.h
FORMS += \
    Form.ui

LIBS += -lgdi32

#CONFIG += console

RESOURCES += \
    icons.qrc
