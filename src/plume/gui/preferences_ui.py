# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file '/home/cyril/Devel/workspace_eric/plume-creator/src/plume/gui/preferences.ui'
#
# Created by: PyQt5 UI code generator 5.4.1
#
# WARNING! All changes made in this file will be lost!

from PyQt5 import QtCore, QtGui, QtWidgets

class Ui_Preferences(object):
    def setupUi(self, Preferences):
        Preferences.setObjectName("Preferences")
        Preferences.resize(631, 508)
        Preferences.setSizeGripEnabled(True)
        Preferences.setModal(True)
        self.verticalLayout = QtWidgets.QVBoxLayout(Preferences)
        self.verticalLayout.setObjectName("verticalLayout")
        self.horizontalLayout_2 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_2.setObjectName("horizontalLayout_2")
        self.previousButton = QtWidgets.QToolButton(Preferences)
        icon = QtGui.QIcon()
        icon.addPixmap(QtGui.QPixmap(":/pics/32x32/arrow-left.png"), QtGui.QIcon.Normal, QtGui.QIcon.Off)
        self.previousButton.setIcon(icon)
        self.previousButton.setIconSize(QtCore.QSize(32, 32))
        self.previousButton.setArrowType(QtCore.Qt.NoArrow)
        self.previousButton.setObjectName("previousButton")
        self.horizontalLayout_2.addWidget(self.previousButton)
        self.titleButton = QtWidgets.QToolButton(Preferences)
        self.titleButton.setText("titleButton")
        self.titleButton.setIconSize(QtCore.QSize(32, 32))
        self.titleButton.setToolButtonStyle(QtCore.Qt.ToolButtonTextBesideIcon)
        self.titleButton.setObjectName("titleButton")
        self.horizontalLayout_2.addWidget(self.titleButton)
        spacerItem = QtWidgets.QSpacerItem(40, 20, QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Minimum)
        self.horizontalLayout_2.addItem(spacerItem)
        self.verticalLayout.addLayout(self.horizontalLayout_2)
        self.stackedWidget = QtWidgets.QStackedWidget(Preferences)
        self.stackedWidget.setObjectName("stackedWidget")
        self.mainPage = QtWidgets.QWidget()
        self.mainPage.setObjectName("mainPage")
        self.verticalLayout_3 = QtWidgets.QVBoxLayout(self.mainPage)
        self.verticalLayout_3.setObjectName("verticalLayout_3")
        self.scrollArea = QtWidgets.QScrollArea(self.mainPage)
        self.scrollArea.setWidgetResizable(True)
        self.scrollArea.setObjectName("scrollArea")
        self.scrollAreaWidgetContents = QtWidgets.QWidget()
        self.scrollAreaWidgetContents.setGeometry(QtCore.QRect(0, 0, 593, 389))
        self.scrollAreaWidgetContents.setObjectName("scrollAreaWidgetContents")
        self.verticalLayout_2 = QtWidgets.QVBoxLayout(self.scrollAreaWidgetContents)
        self.verticalLayout_2.setObjectName("verticalLayout_2")
        self.interfaceBox = QtWidgets.QGroupBox(self.scrollAreaWidgetContents)
        self.interfaceBox.setMinimumSize(QtCore.QSize(0, 60))
        self.interfaceBox.setFlat(False)
        self.interfaceBox.setObjectName("interfaceBox")
        self.interfaceLayout = QtWidgets.QHBoxLayout(self.interfaceBox)
        self.interfaceLayout.setObjectName("interfaceLayout")
        self.verticalLayout_2.addWidget(self.interfaceBox)
        self.editorBox = QtWidgets.QGroupBox(self.scrollAreaWidgetContents)
        self.editorBox.setMinimumSize(QtCore.QSize(0, 60))
        self.editorBox.setObjectName("editorBox")
        self.editorLayout = QtWidgets.QHBoxLayout(self.editorBox)
        self.editorLayout.setObjectName("editorLayout")
        self.verticalLayout_2.addWidget(self.editorBox)
        self.advancedBox = QtWidgets.QGroupBox(self.scrollAreaWidgetContents)
        self.advancedBox.setMinimumSize(QtCore.QSize(0, 60))
        self.advancedBox.setObjectName("advancedBox")
        self.advancedLayout = QtWidgets.QHBoxLayout(self.advancedBox)
        self.advancedLayout.setObjectName("advancedLayout")
        self.verticalLayout_2.addWidget(self.advancedBox)
        self.scrollArea.setWidget(self.scrollAreaWidgetContents)
        self.verticalLayout_3.addWidget(self.scrollArea)
        self.stackedWidget.addWidget(self.mainPage)
        self.verticalLayout.addWidget(self.stackedWidget)
        self.buttonBox = QtWidgets.QDialogButtonBox(Preferences)
        self.buttonBox.setOrientation(QtCore.Qt.Horizontal)
        self.buttonBox.setStandardButtons(QtWidgets.QDialogButtonBox.Apply|QtWidgets.QDialogButtonBox.Cancel|QtWidgets.QDialogButtonBox.Ok)
        self.buttonBox.setObjectName("buttonBox")
        self.verticalLayout.addWidget(self.buttonBox)

        self.retranslateUi(Preferences)
        self.stackedWidget.setCurrentIndex(0)
        self.buttonBox.accepted.connect(Preferences.accept)
        self.buttonBox.rejected.connect(Preferences.reject)
        QtCore.QMetaObject.connectSlotsByName(Preferences)

    def retranslateUi(self, Preferences):

        Preferences.setWindowTitle(_("Dialog"))
        self.previousButton.setText(_("PushButton"))
        self.stackedWidget.setProperty("title", _("Themes"))
        self.mainPage.setProperty("title", _("Preferences"))
        self.interfaceBox.setTitle(_("Interface"))
        self.editorBox.setTitle(_("Editor"))
        self.advancedBox.setTitle(_("Advanced"))


