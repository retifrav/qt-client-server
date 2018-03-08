import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import io.qt.Backend 1.0

Window {
    visible: true
    width: 700
    minimumWidth: 500
    height: 450
    minimumHeight: 200
    title: "Server"
    color: "#CED0D4"

    Backend {
        id: backend
        onSmbConnected: {
            ti.append(addMsg("Somebody has connected"));
        }
        onSmbDisconnected: {
            ti.append(addMsg("Somebody has disconnected"));
        }
        onNewMessage: {
            ti.append(addMsg("New message: " + msg));
        }
    }

    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 10

        RowLayout {
            anchors.horizontalCenter: parent.horizontalCenter

            BetterButton {
                id: btn_start
                anchors.left: parent.left
                text: "Start server"
                color: enabled ? this.down ? "#78C37F" : "#87DB8D" : "gray"
                border.color: "#78C37F"
                onClicked: {
                    ti.append(addMsg(backend.startClicked()));
                    this.enabled = false;
                }
            }
            BetterButton {
                enabled: !btn_start.enabled
                anchors.right: parent.right
                text: "Stop server"
                color: enabled ? this.down ? "#DB7A74" : "#FF7E79" : "gray"
                border.color: "#DB7A74"
                onClicked: {
                    ti.append(addMsg(backend.stopClicked()));
                    btn_start.enabled = true;
                }
            }
        }

        LayoutSection {
            Layout.fillHeight: true

            ScrollView {
                id: scrollView
                anchors.fill: parent

                TextArea {
                    id: ti
                    readOnly: true
                    selectByMouse : true
                    font.pixelSize: 14
                    wrapMode: TextInput.WrapAnywhere
                }
            }
        }

        BetterButton {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Test connection"
            color: this.down ? "#6FA3D2" : "#7DB7E9"
            border.color: "#6FA3D2"
            onClicked: {
                ti.append(addMsg(backend.testClicked()));
            }
        }
    }

    Component.onCompleted: {
        ti.text = addMsg("Application started\n- - - - - -");
    }

    function addMsg(someText)
    {
        return "[" + currentTime() + "] " + someText;
    }

    function currentTime()
    {
        var now = new Date();
        var nowString = ("0" + now.getHours()).slice(-2) + ":"
                + ("0" + now.getMinutes()).slice(-2) + ":"
                + ("0" + now.getSeconds()).slice(-2);
        return nowString;
    }
}
