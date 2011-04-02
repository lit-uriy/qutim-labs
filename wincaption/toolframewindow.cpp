#include "toolframewindow.h"
#include "toolframewindow_p.h"
#include "qtwin.h"
#include <QLibrary>
#include <QToolButton>

typedef HRESULT (WINAPI * DwmDefWindowProc_t)(HWND, UINT, WPARAM, LPARAM, long*);
DwmDefWindowProc_t dwmDefWindowProc = 0;

ToolFrameWindow::ToolFrameWindow() :
	d_ptr(new ToolFrameWindowPrivate(this))
{
	if (!dwmDefWindowProc) {
		QLibrary dwmapi("dwmapi");
		dwmDefWindowProc = reinterpret_cast<DwmDefWindowProc_t>(dwmapi.resolve("DwmDefWindowProc"));
	}
	Q_D(ToolFrameWindow);
	d->loadThemeParams();

	//setAttribute(Qt::WA_TranslucentBackground);
	//setAutoFillBackground(true);

	//QtWin::extendFrameIntoClientArea(this);
	QtWin::extendFrameIntoClientArea(this, d->verticalBorder,
									 d->verticalBorder,
									 d->captionHeight,
									 d->horizontalBorder);

	d->vLayout = new QVBoxLayout(this);
	d->hLayout = new QHBoxLayout(this);
	d->vLayout->addLayout(d->hLayout);
	d->hLayout->addSpacerItem(new QSpacerItem(10, d->captionHeight, QSizePolicy::Expanding, QSizePolicy::Fixed));

	d->vLayout->setContentsMargins(d->verticalBorder, 0, d->verticalBorder, d->horizontalBorder);
	d->hLayout->setSpacing(0);
}

ToolFrameWindow::~ToolFrameWindow()
{

}

void ToolFrameWindow::addAction(QAction *action)
{
	Q_D(ToolFrameWindow);
	QWidget::addAction(action);
	QToolButton *btn = new QToolButton(this);
	btn->setDefaultAction(action);
	btn->setAutoRaise(true);
	addWidget(btn);
}

void ToolFrameWindow::removeAction(QAction *action)
{
	QWidget::removeAction(action);
}

void ToolFrameWindow::addWidget(QWidget *widget)
{
	Q_D(ToolFrameWindow);
	d->hLayout->insertWidget(d->hLayout->count() - 1, widget);
}

void ToolFrameWindow::setCentralWidget(QWidget *widget)
{
	Q_D(ToolFrameWindow);
	if (d->centralWidget)
		layout()->removeWidget(d->centralWidget);
	d->centralWidget = widget;
	layout()->addWidget(widget);
}

bool ToolFrameWindow::winEvent(MSG *msg, long *result)
{
	//return QWidget::winEvent(msg, result); //Viv почему кнопки не жмакаются?
	Q_D(ToolFrameWindow);
	if (!QtWin::isCompositionEnabled())
		return false;
	if (dwmDefWindowProc(msg->hwnd, msg->message, msg->wParam, msg->lParam, result))
		return true;
	switch (msg->message)
	{
	case WM_SHOWWINDOW: {
		RECT rc;
		GetWindowRect(winId(), &rc);
		SetWindowPos(winId(),
					 NULL,
					 rc.left, rc.top,
					 rc.right-rc.left, rc.bottom-rc.top,
					 SWP_FRAMECHANGED);
		return false;
	}
	case WM_NCCALCSIZE:
		*result = d->nativeNcCalcSize(msg, result);
		return true;
	case WM_NCHITTEST:
		*result = d->nativeNcHitTest(msg);
		return true;
	default:
		return false;
	}
}
