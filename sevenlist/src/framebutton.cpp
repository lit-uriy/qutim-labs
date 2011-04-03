#include "framebutton.h"

FrameButton::FrameButton(QWidget *parent) :
    QPushButton(parent)
{
	setMaximumHeight(20);
	setMinimumSize(35, 20);
	setStyleSheet(("QPushButton { "
				   "border: 3px;"
				   "border-image: url(:/sevenlist/redbutton.png);"
				   "}"));

	//setIconSize(QSize(12,12));
}
