import QtQuick 2.15
import Qt.labs.platform 1.1 as LabPlatform
import QtQml 2.15
import eu.skribisto.result 1.0
import "../Items"
import ".."

NewProjectPageForm {
    id: root

    signal closeCalled()
    property string fileName: fileName
    property url folderNameURL

    selectProjectPathToolButton.onClicked: {
        folderDialog.open()
        folderDialog.currentFolder = LabPlatform.StandardPaths.writableLocation(LabPlatform.StandardPaths.DocumentsLocation)


    }


    LabPlatform.FolderDialog{
        id: folderDialog
        folder: LabPlatform.StandardPaths.writableLocation(LabPlatform.StandardPaths.DocumentsLocation)

        onAccepted: {
            folderNameURL = folderDialog.currentFolder
            projectPathTextField.text = skrQMLTools.translateURLToLocalFile(folderNameURL)
        }
        onRejected: {

        }



    }

    property bool projectFileTextFiledEdited: false
    // title :
    projectTitleTextField.onTextChanged: {
        if(!projectFileTextFiledEdited){
            var name = projectTitleTextField.text

            name = name.replace(/[\"\/\%\(\)|.'?!$#\n\r]/g, "");

            projectFileTextField.text = name
        }

    }



    //file :
    projectFileTextField.validator: RegExpValidator { regExp: /^[^ ][\w\s]{1,60}$/ }
    projectFileTextField.onTextChanged: {
        var file = projectPathTextField.text + "/" + projectFileTextField.text + ".skrib"


        fileName = skrQMLTools.setURLScheme(Qt.resolvedUrl(file), "file")
    }
    projectFileTextField.onTextEdited: {
        projectFileTextFiledEdited = true
    }

    // path :
    projectPathTextField.text: {

        var path = skrQMLTools.translateURLToLocalFile(LabPlatform.StandardPaths.writableLocation(LabPlatform.StandardPaths.DocumentsLocation))
        //
        //        path = path.replace(/^(file:\/{2})/,"")

        return path


    }
    projectPathTextField.onTextChanged: {

        folderNameURL = skrQMLTools.setURLScheme(Qt.resolvedUrl(projectPathTextField.text), "file")

        fileName = Qt.resolvedUrl(folderNameURL + "/" + projectFileTextField.text + ".skrib")
    }


    onFileNameChanged: {
        //console.log("onFileNameChanged",fileName.toString() )
        projectDetailPathLabel.text = skrQMLTools.translateURLToLocalFile(fileName)
    }



    // create :

    createNewProjectButton.onClicked: {
        //TODO: test fileName

        // create new hidden empty project
        var result = plmData.projectHub().createNewEmptyProject(fileName, true)

        if(!result){
            return
        }

        var projectId = plmData.projectHub().getLastLoaded()
        //console.log("new project : getLastLoaded : ", projectId)
        plmData.projectHub().setProjectName(projectId, projectTitleTextField.text)

        //        var firstSheetId = -2
        for(var i = 1; i <= partSpinBox.value ; ++i){
            var result = plmData.treeHub().addChildTreeItem(projectId, 0, "TEXT")
            //console.log("new project : add sheet : ", result.isSuccess())
            var treeItemId = plmData.treeHub().getLastAddedId()
            plmData.treeHub().setTitle(projectId, treeItemId, qsTr("Part ") + i)

            //            if(sheetId === 1){
            //                firstSheetId = sheetId
            //            }

        }


        plmData.projectHub().saveProject(projectId)
        plmData.projectHub().closeProject(projectId)
        plmData.projectHub().loadProject(fileName)


        projectId = plmData.projectHub().getLastLoaded()
        rootWindow.viewManager.loadTreeItemAt(projectId, 1, Qt.TopLeftCorner)


        //root_stack.currentIndex = 1
        //Globals.openSheetInNewTabCalled(projectId, firstSheetId)

        //reset :
        projectTitleTextField.text = ""
        projectFileTextField.text = ""
        projectFileTextFiledEdited = false
        projectPathTextField.text = skrQMLTools.translateURLToLocalFile(LabPlatform.StandardPaths.writableLocation(LabPlatform.StandardPaths.DocumentsLocation))

        closeCalled()
    }



    //--------------------------------------------------

    onActiveFocusChanged: {
        if (activeFocus) {
            projectTitleTextField.forceActiveFocus()
        }
    }


}
