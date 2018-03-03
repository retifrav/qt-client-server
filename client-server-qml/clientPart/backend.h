#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include "clientStuff.h"

class Backend : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool currentStatus READ getStatus NOTIFY statusChanged)

public:
    explicit Backend(QObject *parent = nullptr);
    bool getStatus();

signals:
    void statusChanged(QString newStatus);
    void someError(QString err);
    void someMessage(QString msg);

public slots:
    void setStatus(bool newStatus);
    void receivedSomething(QString msg);
    void gotError(QAbstractSocket::SocketError err);
    void sendClicked(QString msg);
    void connectClicked();
    void disconnectClicked();

private:
    ClientStuff *client;
};

#endif // BACKEND_H
