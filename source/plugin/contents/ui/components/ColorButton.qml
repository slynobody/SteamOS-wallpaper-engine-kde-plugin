import QtQuick 2.8
import QtQuick.Controls 2.1
import QtQuick.Dialogs

// Color picker button that shows current color and opens ColorDialog on click
Rectangle {
    id: colorBtn

    property color def_val: "#ffffff"
    property color colorValue: def_val

    // res_val as string for saving in format "r g b"
    property string res_val: {
        const c = colorValue;
        return `${c.r.toFixed(3)} ${c.g.toFixed(3)} ${c.b.toFixed(3)}`;
    }

    implicitWidth: 60
    implicitHeight: 30
    width: 60
    height: 30
    radius: 4
    color: colorValue
    border.color: Qt.darker(colorValue, 1.2)
    border.width: 1

    function finish() {
        colorValue = def_val;
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: colorDialog.open()
    }

    ColorDialog {
        id: colorDialog
        title: "Select Color"
        selectedColor: colorBtn.colorValue
        onAccepted: {
            colorBtn.colorValue = selectedColor;
        }
    }
}
