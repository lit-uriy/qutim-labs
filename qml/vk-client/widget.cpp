#include "widget.h"
#include <QApplication>
#include <QUrl>

Widget::Widget()
{
	setHorizontalScrollBarPolicy ( Qt::ScrollBarAlwaysOff );
	setContextMenuPolicy(Qt::NoContextMenu);
	setVerticalScrollBarPolicy( Qt::ScrollBarAlwaysOff);
	viewport()->setAutoFillBackground(false);
	setContentResizable(true);

	QString filename = qApp->applicationDirPath() + "/client/vkontakte-client.qml";
	setUrl(QUrl::fromLocalFile(filename));
	execute();

}
