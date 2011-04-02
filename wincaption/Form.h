#ifndef FORM_H
#define FORM_H

#include <QWidget>

struct tagMSG;
typedef tagMSG MSG;

namespace Ui {
    class Form;
}

class Form : public QWidget
{
    Q_OBJECT

public:
    explicit Form(QWidget *parent = 0);
    ~Form();

protected:
	//void mousePressEvent(QMouseEvent *);
	bool winEvent(MSG *message, long *result);

private:
	bool nativeNcCalcSize(MSG* msg, long *result);
	Ui::Form *ui;
	void setWindowThemeAtributes(QWidget *w);
	void learnThemeParams();
	quintptr nativeNcHitTest(MSG *msg);

	int winHorBorder_, winVerBorder_, winCaption_;
};

#endif // FORM_H
