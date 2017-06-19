import os
from qgis.utils import iface
from PyQt4.QtCore import QSettings
from PyQt4.QtGui import QAction, QMainWindow

QSettings().setValue( "Plugins/georefplugin", True )

def load_georeferencer():
    iface.mainWindow().findChild(QAction, 'mActionRunGeoref').trigger()
    for x in iface.mainWindow().findChildren(QMainWindow):
        if x.objectName() == 'QgsGeorefPluginGuiBase':
            for y in x.children():
                if 'mActionOpenRaster' in y.objectName():
                    y.trigger()

iface.initializationCompleted.connect(load_georeferencer)
