#include <QApplication>
#include <QWidget>
#include "Form.h"
#include "toolframewindow.h"
#include <QLabel>
#include <QAction>
#include <QTabBar>
#include <QPushButton>
#include "qutim/qtwin.h"
#include <QLabel>
#include <QGraphicsDropShadowEffect>

int main(int argc, char **argv)
{
	QApplication ap(argc, argv);

	ToolFrameWindow w;//(ToolFrameWindow::DisableExtendFrame);
	//QtWin::extendFrameIntoClientArea(&w, true);
	Form form;

	QAction action(&w);
	action.setIcon(QIcon(":/applications-internet.png"));
	QAction action2(&w);
	action2.setIcon(QIcon(":/applications-multimedia.png"));
	QTabBar bar;
	bar.addTab(QObject::tr("main.cpp"));
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

	QLabel lbl(QObject::tr("Glow caption."));
	lbl.setStyleSheet("QLabel {border-image: url(:/background.png);border: 5px; }");
	lbl.setAttribute(Qt::WA_TransparentForMouseEvents);

	w.addWidget(&btn);
	w.addSpace(16);
	w.addAction(&action);
	w.addSeparator();
	w.addAction(&action2);
	w.addWidget(&lbl, Qt::AlignCenter);
	w.addSpace(32);
	w.addWidget(&bar, Qt::AlignBottom);
	w.setCentralWidget(&form);

	//w.setIconSize(QSize(32,32));

	w.show();
	w.resize(600,400);
	return ap.exec();
}
