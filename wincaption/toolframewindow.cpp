#include "toolframewindow.h"
#include "toolframewindow_p.h"
#include "qtwin.h"

ToolFrameWindow::ToolFrameWindow() :
	d_ptr(new ToolFrameWindowPrivate(this))
{
	Q_D(ToolFrameWindow);
	d->loadThemeParams();

	//setAttribute(Qt::WA_TranslucentBackground);
	//setAttribute(Qt::WA_TransparentForMouseEvents);
	//setAutoFillBackground(true);

	QtWin::extendFrameIntoClientArea(this, d->verticalBorder,
									 d->verticalBorder,
									 d->captionHeight,
									 d->horizontalBorder);
}

ToolFrameWindow::~ToolFrameWindow()
{

}

void ToolFrameWindow::addAction(QAction *action)
{
	QWidget::addAction(action);
}

void ToolFrameWindow::removeAction(QAction *action)
{
	QWidget::removeAction(action);
}

QAction *ToolFrameWindow::addWidget(QWidget *widget)
{

}

void ToolFrameWindow::setCentralWidget(QWidget *widget)
{
	Q_D(ToolFrameWindow);
	d->centralWidget = widget;
}

bool ToolFrameWindow::winEvent(MSG *msg, long *result)
{
	Q_D(ToolFrameWindow);
	if (!QtWin::isCompositionEnabled())
		return false;
	//DwmIsCompositionEnabled(&compositionEnabled);
	//if (!compositionEnabled)
	//return false;
	//if (DwmDefWindowProc(msg->hwnd, msg->message, msg->wParam, msg->lParam, result))
	//	return true;
	switch (msg->message)
	{
	case WM_SHOWWINDOW :
	{
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
