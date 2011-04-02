#include <QApplication>
#include <QWidget>
#include "Form.h"

int main(int argc, char **argv)
{
	QApplication ap(argc, argv);
	Form f;
	f.show();
	return ap.exec();
}
