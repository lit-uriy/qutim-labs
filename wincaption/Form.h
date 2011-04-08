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
private:
	Ui::Form *ui;
};

#endif // FORM_H
