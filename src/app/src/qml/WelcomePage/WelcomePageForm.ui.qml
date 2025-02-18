import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import ".."
import "../Items"
import "../Commons"

SkrPane {
    id: base
    property alias goBackButton: goBackButton
    property alias goBackToMenuButton: goBackToMenuButton


    property alias stackView: stackView
    property alias separator: separator
    property alias mainButtonsPane: mainButtonsPane
    property alias newButton: newButton
    property alias recentButton: recentButton
    property alias exampleButton: exampleButton
    property alias openButton: openButton
    property alias saveButton: saveButton
    property alias saveAsButton: saveAsButton
    property alias saveACopyButton: saveACopyButton
    property alias backUpButton: backUpButton
    property alias importButton: importButton
    property alias exportButton: exportButton
    property alias printButton: printButton
    property alias settingsButton: settingsButton
    property alias helpButton: helpButton


    ColumnLayout {
        id: columnLayout2
        spacing: 0
        anchors.fill: parent


        RowLayout {
            id: rowLayout
            Layout.fillWidth: true
            Layout.fillHeight: true

            SkrPane {
                id: mainButtonsPane
                Layout.minimumWidth: 200
                Layout.maximumWidth: 300
                Layout.preferredWidth: 200
                Layout.fillHeight: true

                ColumnLayout {
                    id: columnLayout1
                    anchors.fill: parent

                    SkrToolButton {
                        id: goBackButton
                        text: qsTr("Go Back")
                        focusPolicy: Qt.NoFocus
                        display: AbstractButton.IconOnly
                        Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                        icon {
                            source: "qrc:///icons/backup/go-previous.svg"
                        }
                    }

                    SkrToolButton {
                        id: newButton
                        text: qsTr("New")
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40
                        display: AbstractButton.TextBesideIcon
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                        icon {
                            source: "qrc:///icons/backup/document-new.svg"
                        }
                    }

                    SkrToolButton {
                        id: recentButton
                        text: qsTr("Recent")
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40
                        display: AbstractButton.TextBesideIcon
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    }

                    SkrToolButton {
                        id: openButton
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40
                        display: AbstractButton.TextBesideIcon
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    }

                    SkrToolButton {
                        id: saveButton
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40
                        display: AbstractButton.TextBesideIcon
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    }
                    SkrToolButton {
                        id: saveAsButton
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40
                        display: AbstractButton.TextBesideIcon
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    }
                    SkrToolButton {
                        id: backUpButton
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40
                        display: AbstractButton.TextBesideIcon
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    }
                    SkrToolButton {
                        id: saveACopyButton
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40
                        display: AbstractButton.TextBesideIcon
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    }
                    SkrToolButton {
                        id: exampleButton
                        text: qsTr("Examples")
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40
                        display: AbstractButton.TextBesideIcon
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    }

                    SkrToolButton {
                        id: importButton
                        text: qsTr("Import")
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40
                        display: AbstractButton.TextBesideIcon
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    }

                    SkrToolButton {
                        id: exportButton
                        text: qsTr("Export")
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40
                        display: AbstractButton.TextBesideIcon
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    }

                    SkrToolButton {
                        id: printButton
                        text: qsTr("Print")
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40
                        display: AbstractButton.TextBesideIcon
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    }

                    SkrToolButton {
                        id: settingsButton
                        text: qsTr("Settings")
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40
                        display: AbstractButton.TextBesideIcon
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    }


                    SkrToolButton {
                        id: helpButton
                        text: qsTr("Help")
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40
                        display: AbstractButton.TextBesideIcon
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    }

                    Item {
                        id: element
                        Layout.preferredWidth: 10
                        Layout.fillHeight: true
                    }
                }
            }

            Rectangle {
                id: separator
                Layout.preferredWidth: 2
                Layout.preferredHeight: base.height * 3 / 4
                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                gradient: Gradient {
                    orientation: Qt.Vertical
                    GradientStop {
                        position: 0.00;
                        color: "transparent";
                    }
                    GradientStop {
                        position: 0.30;
                        color:  SkrTheme.divider;
                    }
                    GradientStop {
                        position: 0.70;
                        color: SkrTheme.divider;
                    }
                    GradientStop {
                        position: 1.00;
                        color: "transparent";
                    }
                }

            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                SkrToolButton {
                    id: goBackToMenuButton
                    text: qsTr("Go Back to the menu")
                    display: AbstractButton.IconOnly
                    Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                    icon {
                        source: "qrc:///icons/backup/go-previous.svg"
                    }
                }
                StackView {
                    id: stackView
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    initialItem: Item {}


                }
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:3;anchors_height:100;anchors_width:100}
D{i:12;anchors_height:200;anchors_width:200}D{i:13;anchors_height:100;anchors_width:100;anchors_x:0;anchors_y:0}
D{i:14;anchors_height:100;anchors_width:100;anchors_x:0;anchors_y:0}D{i:9;anchors_height:100;anchors_width:100}
D{i:30;anchors_height:200;anchors_width:200}D{i:31;anchors_height:100;anchors_width:100}
D{i:34;anchors_height:100;anchors_width:100}D{i:19;anchors_height:100;anchors_width:100;anchors_x:0;anchors_y:0}
D{i:18;anchors_height:200;anchors_width:200}D{i:38;anchors_height:100;anchors_width:100}
D{i:37;anchors_height:200;anchors_width:200}D{i:7;anchors_height:100;anchors_width:100}
D{i:1;anchors_height:100;anchors_width:100}
}
##^##*/

