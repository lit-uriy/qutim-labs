#include "Form.h"
#include "ui_Form.h"
#include <qt_windows.h>
#include <qtwin.h>
#include <QToolButton>

Form::Form(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Form)
{
	ui->setupUi(this);
}

Form::~Form()
{
    delete ui;
}
