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
	QToolButton *btn = new QToolButton(this);

	learnThemeParams();

	setAttribute(Qt::WA_TranslucentBackground);

	//MARGINS m = {0};
	//m.cyTopHeight    = winHorBorder_ + winCaption_;
	//m.cyBottomHeight = winHorBorder_;
	//m.cxLeftWidth    = m.cxRightWidth = winVerBorder_;
	//DwmExtendFrameIntoClientArea(winId(), &m);
	QtWin::extendFrameIntoClientArea(this,
									 winVerBorder_,
									 winHorBorder_,
									 qMax(winCaption_, btn->height()),
									 winHorBorder_);

	ui->gridLayout->setContentsMargins(winVerBorder_, 0, winVerBorder_, winHorBorder_);
	//ui->horizontalLayout->setContentsMargins(winHorBorder_, 1, 0, 0);
}

//void Form::setWindowThemeAtributes(QWidget *w)
//{
//	enum WTNCA_Flags {
//		_WTNCA_NODRAWCAPTION = 0x00000001,
//		_WTNCA_NODRAWICON    = 0x00000002,
//		_WTNCA_NOSYSMENU     = 0x00000004
//	};

//	enum _WINDOWTHEMEATTRIBUTETYPE
//	{
//		 _WTA_NONCLIENT = 1
//	};

//	struct _WTA_OPTIONS {
//		DWORD flags;
//		DWORD mask;
//	} wta_options;

//	typedef HRESULT (WINAPI * SetWindowThemeAttribute_t)(HWND, _WINDOWTHEMEATTRIBUTETYPE, _WTA_OPTIONS*, DWORD);

//	const DWORD WTNCA_combination = _WTNCA_NODRAWCAPTION | _WTNCA_NODRAWICON | _WTNCA_NOSYSMENU;
//	SetWindowThemeAttribute_t pSetWindowThemeAttribute = 0;

//	QLibrary uxtheme("uxtheme.dll");

//	pSetWindowThemeAttribute = static_cast<SetWindowThemeAttribute_t>(uxtheme.resolve("SetWindowThemeAttribute"));
//	Q_ASSERT_X(pSetWindowThemeAttribute, "resolve", "This module doesn't handle uxtheme.dll miss. Yet.");

//	wta_options.flags = WTNCA_combination;
//	wta_options.mask  = WTNCA_combination;
//	pSetWindowThemeAttribute(w->winId(), _WTA_NONCLIENT, &wta_options, sizeof(wta_options));
//}

void Form::learnThemeParams()
{
	winHorBorder_ = GetSystemMetrics(SM_CYFRAME);
	winVerBorder_ = GetSystemMetrics(SM_CXFRAME);
	winCaption_   = GetSystemMetrics(SM_CYCAPTION);
}

bool Form::winEvent(MSG *msg, long *result)
{
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
		*result = nativeNcCalcSize(msg, result);
		return true;
	case WM_NCHITTEST:
		*result = nativeNcHitTest(msg);
		return true;
	default:
		return false;
	}
}

bool Form::nativeNcCalcSize(MSG *msg, long *result)
{
	msg;
	*result = 0;
	return true;
}

Form::~Form()
{
    delete ui;
}

quintptr Form::nativeNcHitTest(MSG *msg)
{
	QPoint mouseHit(LOWORD(msg->lParam), HIWORD(msg->lParam));
	RECT windowRect = {0};
	GetWindowRect(this->winId(), &windowRect);

	int row = 1;
	int col = 1;
	bool onBorder = false;

	const int LeftOrTop = 0;
	const int RightOrBottom = 2;

	if (mouseHit.y() >= windowRect.top && mouseHit.y() < windowRect.top+winHorBorder_+winCaption_) {
		onBorder = (mouseHit.y() < windowRect.top + winHorBorder_);
		row = LeftOrTop;
	} else if (mouseHit.y() < windowRect.bottom && mouseHit.y() >= windowRect.bottom - winHorBorder_) {
		row = RightOrBottom;
	}

	if (mouseHit.x() >= windowRect.left && mouseHit.x() < windowRect.left+winVerBorder_) {
		col = LeftOrTop;
	}
	else if (mouseHit.x() < windowRect.right && mouseHit.x() >= windowRect.right - winVerBorder_) {
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
