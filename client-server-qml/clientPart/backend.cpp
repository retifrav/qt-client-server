#include "backend.h"

Backend::Backend(QObject *parent) : QObject(parent)
{
    client = new ClientStuff("localhost", 6547);

    //setStatus(client->get_status());

    connect(client, &ClientStuff::hasReadSome, this, &Backend::receivedSomething);
    connect(client, &ClientStuff::statusChanged, this, &Backend::setStatus);
    // FIXME change this connection to the new syntax
    connect(client->tcpSocket, SIGNAL(error(QAbstractSocket::SocketError)),
            this, SLOT(gotError(QAbstractSocket::SocketError)));
}

bool Backend::getStatus()
{
    return client->getStatus();
}

void Backend::setStatus(bool newStatus)
{
    //qDebug() << "new status is:" << newStatus;
    if (newStatus)
        { emit statusChanged("CONNECTED"); }
    else
        { emit statusChanged("DISCONNECTED"); }
}

void Backend::receivedSomething(QString msg)
{
    emit someMessage(msg);
}

void Backend::gotError(QAbstractSocket::SocketError err)
{
    //qDebug() << "got error";
    QString strError = "unknown";
    switch (err)
    {
        case 0:
            strError = "Connection was refused";
            break;
        case 1:
            strError = "Remote host closed the connection";
            break;
        case 2:
            strError = "Host address was not found";
            break;
        case 5:
            strError = "Connection timed out";
            break;
        default:
            strError = "Unknown error";
    }

    emit someError(strError);
}

void Backend::connectClicked()
{
    client->connect2host();
}

void Backend::sendClicked(QString msg)
{
    QByteArray arrBlock;
    QDataStream out(&arrBlock, QIODevice::WriteOnly);
    //out.setVersion(QDataStream::Qt_5_10);
    out << quint16(0) << msg;

    out.device()->seek(0);
    out << quint16(arrBlock.size() - sizeof(quint16));

    client->tcpSocket->write(arrBlock);
}

void Backend::disconnectClicked()
{
    client->closeConnection();
}
