import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import ".."

Dial {
    id: control

    Material.background: SkrTheme.buttonBackground
    Material.foreground: SkrTheme.buttonForeground
    Material.accent: SkrTheme.accent



    SkrFocusIndicator {
        parent: control.background
        anchors.fill: control.background
        visible: control.activeFocus & Globals.focusVisible

    }
    Keys.onPressed: {
        if (event.key === Qt.Key_Tab){
            Globals.setFocusTemporarilyVisible()
        }
    }


    property string tip
    hoverEnabled: true

    SkrToolTip {
        text: control.tip
        visible: control.hovered && tip.length !== 0
    }
}
