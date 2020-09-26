import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Qt.labs.settings 1.1
import eu.skribisto.notelistproxymodel 1.0
import eu.skribisto.searchnotelistproxymodel 1.0
import eu.skribisto.writedocumentlistmodel 1.0
import eu.skribisto.skrusersettings 1.0
import ".."

LeftDockForm {


    SkrUserSettings {
        id: skrUserSettings
    }


    splitView.handle: Item {
        implicitHeight: 8
        RowLayout {
            anchors.fill: parent
            Rectangle {
                Layout.preferredWidth: 20
                Layout.preferredHeight: 5
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                color: "lightgrey"
            }
        }
    }



    //-----------------------------------------------------------



    Shortcut {
        id: navigationMenuShortcut
        enabled: root.enabled

    }



    //-----------------------------------------------------------



    //Menu :
    property list<Component> menuComponents:  [
        Component{
            id:  navigationDockMenuComponent
            Menu {
                id: navigationDockMenu
                objectName: "navigationDockMenu"
                title: qsTr("&Navigation dock")

                Component.onCompleted: {

                    navigationMenuShortcut.sequence = skrQMLTools.mnemonic(title)
                    navigationMenuShortcut.activated.connect(function() {
                        Globals.openSubMenuCalled(navigationDockMenu)
                    })
                }


                MenuItem {
                    text: qsTr("&Navigation")
                    onTriggered: {
                        if(Globals.compactSize){
                            leftDrawer.open()
                        }
                        navigationFrame.folded = false
                        navigation.forceActiveFocus()
                    }
                }

                MenuItem {
                    text: qsTr("&Documents")
                    onTriggered: {
                        if(Globals.compactSize){
                            leftDrawer.open()
                        }
                        documentFrame.folded = false
                        documentView.forceActiveFocus()
                    }
                }
            }
        }
    ]
    //Navigation List :
    //-----------------------------------------------------------

    PLMNoteListProxyModel {
        id: proxyModel
    }

    navigation.treeListViewProxyModel: proxyModel

    SKRSearchNoteListProxyModel {
        id: trashedNoteProxyModel
        showTrashedFilter: true
        showNotTrashedFilter: false
    }
    navigation.trashedListViewProxyModel: trashedNoteProxyModel

    //    Connections {
    //        target: Globals
    //        onOpenSheetCalled: function (projectId, paperId) {

    //           proxyModel.setCurrentPaperId(projectId, paperId)


    //        }
    //    }








    //-----------------------------------------------------------

    //Document List :
    //-----------------------------------------------------------
//    documentView.model: plmModels.noteDocumentListModel()
//    documentView.documentModel: plmModels.noteDocumentListModel()

    //-----------------------------------------------------------


    //-----------------------------------------------------------

    //-----------------------------------------------------------
    transitions: [
        Transition {

            PropertyAnimation {
                properties: "implicitWidth"
                easing.type: Easing.InOutQuad
                duration: 500
            }
        }
    ]

    property alias settings: settings

    Settings {
        id: settings
        category: "noteLeftDock"
        property var dockSplitView
        property bool navigationFrameFolded: navigationFrame.folded
        property bool documentFrameFolded: documentFrame.folded
    }

    function setCurrentPaperId(projectId, paperId) {
        proxyModel.setCurrentPaperId(projectId, paperId)
    }
    function setOpenedPaperId(projectId, paperId) {
        navigation.openedProjectId = projectId
        navigation.openedPaperId = paperId
    }


    //    PropertyAnimation {
    //        target: writeNavigationFrame
    //        property: "SplitView.preferredHeight"
    //        duration: 500
    //        easing.type: Easing.InOutQuad
    //    }

    function loadConf(){
        navigationFrame.folded = settings.navigationFrameFolded
        documentFrame.folded = settings.documentFrameFolded
        splitView.restoreState(settings.dockSplitView)
    }

    function resetConf(){
        navigationFrame.folded = false
        documentFrame.folded = false
        splitView.restoreState("")

    }

    Component.onCompleted: {

        loadConf()
        navigation.openDocument.connect(Globals.openNoteCalled)
        navigation.openDocumentInNewTab.connect(Globals.openNoteInNewTabCalled)
        navigation.openDocumentInNewWindow.connect(Globals.openNoteInNewWindowCalled)
        Globals.resetDockConfCalled.connect(resetConf)

    }

    Component.onDestruction: {

        settings.dockSplitView = splitView.saveState()

    }

    onEnabledChanged: {
        if(enabled){

        }
    }
}
