#ifndef TOOLFRAMEWINDOW_P_H
#define TOOLFRAMEWINDOW_P_H
#include <QHBoxLayout>
#include <QVBoxLayout>
#include <qt_windows.h>

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
		msg;
		*result = 0;
		return true;
	}
	ToolFrameWindow *q_ptr;
	QWidget *centralWidget;
	int horizontalBorder;
	int verticalBorder;
	int captionHeight;

};



#endif // TOOLFRAMEWINDOW_P_H
