#ifndef FRAMEBUTTON_H
#define FRAMEBUTTON_H

#include <QPushButton>

class FrameButton : public QPushButton
{
    Q_OBJECT
public:
	explicit FrameButton(QWidget *parent = 0);
};

#endif // FRAMEBUTTON_H
