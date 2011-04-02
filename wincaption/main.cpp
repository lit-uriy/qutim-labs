#include <QApplication>
#include <QWidget>
#include "Form.h"
#include "toolframewindow.h"
#include <QLabel>
#include <QAction>
#include <QTabBar>

int main(int argc, char **argv)
{
	QApplication ap(argc, argv);
	//Form f;
	//f.show();
	ToolFrameWindow w;
	Form form;

	QAction action(&w);
	action.setIcon(QIcon(":/applications-internet.png"));
	QAction action2(&w);
	action2.setIcon(QIcon(":/applications-multimedia.png"));
	QTabBar bar;
	bar.addTab(QObject::tr("My super tab"));
	bar.addTab(QObject::tr("Another tab"));

	w.addAction(&action);
	w.addAction(&action2);
	w.addWidget(&bar);
	w.setCentralWidget(&form);
	w.show();
	return ap.exec();
}
