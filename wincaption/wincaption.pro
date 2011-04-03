QT       += core gui
TARGET = tmp
TEMPLATE = app

SOURCES += main.cpp \
    Form.cpp \
    ../sevenlist/src/toolframewindow.cpp \
    qutim/qtwin.cpp \
    qutim/qtdwm.cpp

HEADERS += \
    Form.h \
    ../sevenlist/src/toolframewindow_p.h \
    ../sevenlist/src/toolframewindow.h \
    qutim/qtwin.h \
    qutim/qtdwm_p.h \
    qutim/qtdwm.h
FORMS += \
    Form.ui
INCLUDEPATH += ../sevenlist/src/

LIBS += -lgdi32

DEFINES += CAPTION_BUILDS

RESOURCES += \
    icons.qrc
