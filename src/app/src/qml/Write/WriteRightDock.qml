import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Qt.labs.settings 1.1
import eu.skribisto.sheetlistproxymodel 1.0
import eu.skribisto.writedocumentlistmodel 1.0
import eu.skribisto.skrusersettings 1.0
import eu.skribisto.searchtaglistproxymodel 1.0
import eu.skribisto.taghub 1.0
import ".."

WriteRightDockForm {

    property int projectId : -2
    property int paperId : -2

    SkrUserSettings {
        id: skrUserSettings
    }

    // fold :
    property bool folded: settings.dockFolded
    onFoldedChanged: folded ? fold() : unfold()

    function fold() {
        state = "dockFolded"
        settings.dockFolded = true
        folded = true
    }
    function unfold() {
        state = "dockUnfolded"
        settings.dockFolded = false
        folded = false
    }

    //    splitView.handle: Rectangle {
    //        implicitWidth: 4
    //        implicitHeight: 4
    //    }


    //-----------------------------------------------------------











    //-----------------------------------------------------------
    //---------------Tags :---------------------------------------------
    //-----------------------------------------------------------


    //proxy model for tag list :

    SKRSearchTagListProxyModel {
        id: tagProxyModel
        projectIdFilter: projectId
        sheetIdFilter: paperId
    }
    tagPadView.tagListModel: tagProxyModel

    Connections{
        target: tagPadView
        function onCallRemoveTagRelationship(projectId, itemId, tagId){
            plmData.tagHub().removeTagRelationship(projectId, SKRTagHub.Sheet , itemId, tagId)
        }
    }

    Connections{
        target: tagPadView
        function onCallAddTagRelationship(projectId, itemId, tagName){
            console.log("aaaaaaa")
            var error;
            // verify if name doesn't already exist :
            var tagId = plmData.tagHub().getTagIdWithName(projectId, tagName)

            if(tagId === -2){
                //if not, create tag
                error = plmData.tagHub().addTag(projectId, tagName)
                tagId = plmData.tagHub().getLastAddedId()
            }

            // set relationship
            error = plmData.tagHub().setTagRelationship(projectId, SKRTagHub.Sheet, itemId, tagId)
            if (!error.success){
                console.log("error onCallAddTagRelationship")
                //TODO: add notification
                return
            }
        }
    }


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

    Settings {
        id: settings
        category: "writeRightDock"
        //property string dockSplitView: "0"
        property bool dockFolded: false
        property bool editFrameFolded: editFrame.folded ? true : false
        property bool notePadFrameFolded: notePadFrame.folded ? true : false
        property bool tagPadFrameFolded: tagPadFrame.folded ? true : false
        //        property bool documentFrameFolded: documentFrame.folded ? true : false
        property int width: fixedWidth
    }


    onProjectIdChanged: {
        notePadView.projectId = projectId
        tagPadView.projectId = projectId
    }
    onPaperIdChanged: {
        notePadView.sheetId = paperId
        tagPadView.itemId = paperId
    }
    //    PropertyAnimation {
    //        target: writeTreeViewFrame
    //        property: "SplitView.preferredHeight"
    //        duration: 500
    //        easing.type: Easing.InOutQuad
    //    }
    Component.onCompleted: {
        folded ? fold() : unfold()

        editFrame.folded = settings.editFrameFolded
        notePadFrame.folded = settings.notePadFrameFolded
        tagPadFrame.folded = settings.tagPadFrameFolded

        //        splitView.restoreState(settings.dockSplitView)
        //treeView.onOpenDocument.connect(Globals.openSheetCalled)
        fixedWidth = settings.width
    }
    Component.onDestruction: {
        //        settings.dockSplitView = splitView.saveState()
        settings.dockFolded = folded
    }
}
