#include <QApplication>
#include <QWidget>
#include "Form.h"
#include "toolframewindow.h"
#include <QLabel>
#include <QAction>
#include <QTabBar>
#include <QPushButton>
#include "qtwin.h"

int main(int argc, char **argv)
{
	QApplication ap(argc, argv);
	//Form f;
	//f.show();
	ToolFrameWindow w;//(ToolFrameWindow::DisableExtendFrame);
	//QtWin::extendFrameIntoClientArea(&w, true);
	Form form;

	QAction action(&w);
	action.setIcon(QIcon(":/applications-internet.png"));
	QAction action2(&w);
	action2.setIcon(QIcon(":/applications-multimedia.png"));
	QTabBar bar;
	bar.addTab(QObject::tr("My super tab"));
	bar.addTab(QObject::tr("Another tab"));
	bar.setTabsClosable(true);
	bar.setMovable(true);

	QPushButton btn;
	btn.setIcon(QIcon(":/ubuntu.png"));
	btn.setStyleSheet("QPushButton { "
					  "border: 5px;"
					  "border-image: url(:/button.png);"
					  "}");
	btn.setMinimumSize(64, 22);
	btn.setMaximumSize(64, 22);

	w.addWidget(&btn);
	w.addAction(&action);
	w.addSeparator();
	w.addAction(&action2);
	w.addWidget(&bar, Qt::AlignBottom);
	w.setCentralWidget(&form);

	//w.setIconSize(QSize(32,32));

	w.show();
	w.resize(600,400);
	return ap.exec();
}
