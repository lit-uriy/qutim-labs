#include "framebutton.h"
#include <QGraphicsDropShadowEffect>
#include <QMouseEvent>
#include <QMessageBox>

class FrameButtonPrivate
{
public:
	QGraphicsDropShadowEffect effect;
};

FrameButton::FrameButton(QWidget *parent) :
	QPushButton(parent), d_ptr(new FrameButtonPrivate)
{
	Q_D(FrameButton);
	d->effect.setColor(QColor(255, 50, 50));
	d->effect.setBlurRadius(22);
	d->effect.setOffset(1);
	d->effect.setEnabled(false);
	setGraphicsEffect(&d_func()->effect);


	setMaximumHeight(20);
	setMinimumSize(35, 20);
	setStyleSheet(("QPushButton { "
				   "border: 3px;"
				   "border-image: url(:/sevenlist/redbutton.png);"
				   "}"));

	//setIconSize(QSize(12,12));
}

FrameButton::~FrameButton()
{

}

void FrameButton::enterEvent(QEvent *e)
{
	d_func()->effect.setEnabled(true);
	QPushButton::enterEvent(e);
}

void FrameButton::leaveEvent(QEvent *e)
{
	d_func()->effect.setEnabled(false);
	QPushButton::leaveEvent(e);
}


