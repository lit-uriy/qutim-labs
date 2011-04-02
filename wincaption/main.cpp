#include <QApplication>
#include <QWidget>
#include "Form.h"
#include "toolframewindow.h"

int main(int argc, char **argv)
{
	QApplication ap(argc, argv);
	//Form f;
	//f.show();
	ToolFrameWindow w;
	w.show();
	return ap.exec();
}
