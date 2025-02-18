import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import "../Commons"
import "../Items"
import ".."

Item {
    id: base
    width: 400
    height: 400
    property alias outlineWritingZone: outlineWritingZone
    property bool minimalMode: false
    property alias openOutlineToolButton: openOutlineToolButton
    property alias addOutlineToolButton: addOutlineToolButton

    implicitHeight: columnLayout.childrenRect.height

    SkrPane {
        id: pane
        clip: true
        anchors.fill: parent
        padding: minimalMode ? 0 : undefined

        Material.background: "transparent"

        ColumnLayout {
            id: columnLayout
            spacing: 0
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom:  minimalMode ? parent.bottom : undefined


            SkrToolBar {
                id: toolBar
                Layout.maximumHeight: 40
                Layout.preferredHeight: 40
                Layout.alignment: Qt.AlignTop
                Layout.fillWidth: true
                visible: !minimalMode


                RowLayout {
                    id: rowLayout
                    spacing: 1
                    anchors.fill: parent

                    SkrLabel {
                        id: outlineTitleLabel
                        text: qsTr("Outline")
                        elide: Text.ElideRight
                        verticalAlignment: Qt.AlignVCenter
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                    }

                    SkrToolButton {
                        id: openOutlineToolButton                    }

                    SkrToolButton {
                        id: addOutlineToolButton                    }

                }

            }

            WritingZone {
                id: outlineWritingZone
                placeholderText: qsTr("Type your outline here...")
                Layout.fillWidth: true
                Layout.preferredHeight: 400
                stretch: true
                leftScrollItemVisible: false
                visible: !minimalMode

                textAreaStyleBackgroundColor: SkrTheme.secondaryTextAreaBackground
                textAreaStyleForegroundColor: SkrTheme.secondaryTextAreaForeground
                paneStyleBackgroundColor: SkrTheme.pageBackground
                textAreaStyleAccentColor: SkrTheme.accent

                Behavior on Layout.preferredHeight {
                    SpringAnimation {
                        spring: 5
                        mass: 0.2
                        damping: 0.2
                    }
                }
            }
        }



    }

}
