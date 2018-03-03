QT += core gui network widgets

TEMPLATE = app
TARGET = server

MOC_DIR     += generated/mocs
UI_DIR      += generated/uis
RCC_DIR     += generated/rccs
OBJECTS_DIR += generated/objs

SOURCES += \
    main.cpp \
    mainwindow.cpp \
    serverStuff.cpp

HEADERS += \
    mainwindow.h \
    serverStuff.h

FORMS += \
    mainwindow.ui
