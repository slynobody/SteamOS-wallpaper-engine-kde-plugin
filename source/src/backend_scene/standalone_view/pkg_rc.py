# Resource object code (Python 3)
# Created by: object code
# Created by: The Resource Compiler for Qt version 6.5.1
# WARNING! All changes made in this file will be lost!

from PySide6 import QtCore

qt_resource_data = b"\
\x00\x00\x01Q\
i\
mport QtQuick 2.\
5\x0aimport QtQuick\
.Controls 2.2\x0a\x0ai\
mport scenetest \
1.0\x0a\x0aItem {\x0a    \
id: root\x0a    wid\
th: 1280\x0a    hei\
ght: 720\x0a\x0a    Sc\
eneViewer {\x0a    \
    id: renderer\
\x0a        anchors\
.fill: parent\x0a  \
      fps: 15\x0a  \
  }\x0a    Timer {\x0a\
        running:\
 false\x0a        r\
epeat: false\x0a   \
     interval: 1\
000*5\x0a        on\
Triggered: {\x0a   \
     }\x0a    } \x0a}\x0a\
\
"

qt_resource_name = b"\
\x00\x03\
\x00\x00w\x17\
\x00p\
\x00k\x00g\
\x00\x08\
\x08\x01Z\x5c\
\x00m\
\x00a\x00i\x00n\x00.\x00q\x00m\x00l\
"

qt_resource_struct = b"\
\x00\x00\x00\x00\x00\x02\x00\x00\x00\x01\x00\x00\x00\x01\
\x00\x00\x00\x00\x00\x00\x00\x00\
\x00\x00\x00\x00\x00\x02\x00\x00\x00\x01\x00\x00\x00\x02\
\x00\x00\x00\x00\x00\x00\x00\x00\
\x00\x00\x00\x0c\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\
\x00\x00\x01\x82\x17 \x94)\
"

def qInitResources():
    QtCore.qRegisterResourceData(0x03, qt_resource_struct, qt_resource_name, qt_resource_data)

def qCleanupResources():
    QtCore.qUnregisterResourceData(0x03, qt_resource_struct, qt_resource_name, qt_resource_data)

qInitResources()
