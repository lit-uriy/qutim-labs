#ifndef TOOLFRAMEWINDOW_P_H
#define TOOLFRAMEWINDOW_P_H
#include <QHBoxLayout>
#include <QVBoxLayout>
#include <qt_windows.h>
#include <QPointer>
#include "qtwin.h"
#include <QHash>
#include <QToolButton>
#include <QTimer>

class QAction;
class ToolFrameWindow;
class ToolFrameWindowPrivate
{
	Q_DECLARE_PUBLIC(ToolFrameWindow)
public:
	ToolFrameWindowPrivate(ToolFrameWindow *q) : q_ptr(q) {}
	void loadThemeParams()
	{
		horizontalBorder = GetSystemMetrics(SM_CYFRAME);
		verticalBorder = GetSystemMetrics(SM_CXFRAME);
		captionHeight   = GetSystemMetrics(SM_CYCAPTION);
	}
	quintptr nativeNcHitTest(MSG *msg)
	{
		Q_Q(ToolFrameWindow);
		QPoint mouseHit(LOWORD(msg->lParam), HIWORD(msg->lParam));
		RECT windowRect = {0};
		GetWindowRect(q->winId(), &windowRect);

		int row = 1;
		int col = 1;
		bool onBorder = false;

		const int LeftOrTop = 0;
		const int RightOrBottom = 2;

		if (mouseHit.y() >= windowRect.top && mouseHit.y() < windowRect.top+horizontalBorder+captionHeight) {
			onBorder = (mouseHit.y() < windowRect.top + verticalBorder);
			row = LeftOrTop;
		} else if (mouseHit.y() < windowRect.bottom && mouseHit.y() >= windowRect.bottom - horizontalBorder) {
			row = RightOrBottom;
		}

		if (mouseHit.x() >= windowRect.left && mouseHit.x() < windowRect.left+ verticalBorder) {
			col = LeftOrTop;
		}
		else if (mouseHit.x() < windowRect.right && mouseHit.x() >= windowRect.right - verticalBorder) {
			col = RightOrBottom;
		}

		quintptr hitTests[3][3] =
		{
			{ HTTOPLEFT,    onBorder ? HTTOP : HTCAPTION,    HTTOPRIGHT },
			{ HTLEFT,       HTNOWHERE,     HTRIGHT },
			{ HTBOTTOMLEFT, HTBOTTOM, HTBOTTOMRIGHT },
		};

		return hitTests[row][col];
	}
	bool nativeNcCalcSize(MSG *msg, long *result)
	{
		//msg;
		*result = 0;
		return true;
	}
	void updateButtons()
	{
		foreach (QToolButton *btn, buttonHash) {
			btn->setIconSize(iconSize);
		}
		QTimer::singleShot(0, q_func(), SLOT(_q_do_layout()));
	}
	void _q_do_layout()
	{
		int height = qMax(captionHeight, hLayout->sizeHint().height());
		QtWin::extendFrameIntoClientArea(q_func(), verticalBorder,
										 verticalBorder,
										 height,
										 horizontalBorder);
	}

	ToolFrameWindow *q_ptr;
	QPointer<QWidget> centralWidget;
	int horizontalBorder;
	int verticalBorder;
	int captionHeight;
	QVBoxLayout *vLayout;
	QHBoxLayout *hLayout;
	QSize iconSize;
	QHash<QAction*, QToolButton*> buttonHash;
};


#endif // TOOLFRAMEWINDOW_P_H
