#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include "serverStuff.h"

class Backend : public QObject
{
    Q_OBJECT
public:
    explicit Backend(QObject *parent = nullptr);

signals:
    void smbConnected();
    void smbDisconnected();
    void newMessage(QString msg);

public slots:
    QString stopClicked();
    QString startClicked();
    QString testClicked();
    void smbConnectedToServer();
    void smbDisconnectedFromServer();
    void gotNewMesssage(QString msg);

private:
    ServerStuff *server;
};

#endif // BACKEND_H
