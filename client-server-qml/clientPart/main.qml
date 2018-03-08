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
    title: "Client"
    color: "#CED0D4"

    Backend {
        id: backend

        onStatusChanged: {
            //console.log(currentStatus);
            ti.append(addMsg(newStatus));
            if (currentStatus !== true)
            {
                btn_connect.enabled = true;
            }
        }
        onSomeMessage: {
            ti.append(addMsg(msg));
        }
        onSomeError: {
            ti.append(addMsg("Error! " + err));
            if (currentStatus !== true)
            {
                backend.disconnectClicked();
            }
            btn_connect.enabled = true;
        }
    }

    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 10

        LayoutSection {
            height: status.height + 15
            color: backend.currentStatus ? "#CAF5CF" : "#EA9FA9"

            Text {
                id: status
                anchors.centerIn: parent
                text: backend.currentStatus ? "CONNECTED" : "DISCONNECTED"
                font.weight: Font.Bold
            }
        }

        RowLayout {
            anchors.horizontalCenter: parent.horizontalCenter

            BetterButton {
                id: btn_connect
                anchors.left: parent.left
                text: "Connect to server"
                color: enabled ? this.down ? "#78C37F" : "#87DB8D" : "gray"
                border.color: "#78C37F"
                onClicked: {
                    ti.append(addMsg("Connecting to server..."));
                    backend.connectClicked();
                    this.enabled = false;
                }
            }
            BetterButton {
                id: btn_disconnect
                enabled: !btn_connect.enabled
                anchors.right: parent.right
                text: "Disconnect from server"
                color: enabled ? this.down ? "#DB7A74" : "#FF7E79" : "gray"
                border.color: "#DB7A74"
                onClicked: {
                    ti.append(addMsg("Disconnecting from server..."));
                    backend.disconnectClicked();
                    btn_connect.enabled = true;
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

        RowLayout {
            Layout.leftMargin: 15
            Layout.rightMargin: 15
            Layout.topMargin: 5
            Layout.bottomMargin: 5

            Rectangle {
                Layout.fillWidth: true
                height: btn_send.height
                color: "#F4F2F5"
                border.color: "gray"
                border.width: 1

                TextInput {
                    id: msgToSend
                    anchors.verticalCenter: parent.verticalCenter
                    leftPadding: 10
                    rightPadding: 10
                    width: parent.width
                    font.pixelSize: 14
                    clip: true
                }
            }

            BetterButton {
                id: btn_send
                enabled: !btn_connect.enabled
                text: "Send"
                color: enabled ? this.down ? "#6FA3D2" : "#7DB7E9" : "gray"
                border.color: "#6FA3D2"
                onClicked: {
                    ti.append(addMsg("Sending message..."));
                    backend.sendClicked(msgToSend.text);
                }
            }
        }
    }

    Component.onCompleted: {
        ti.text = addMsg("Application started\n- - - - - -", false);
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
