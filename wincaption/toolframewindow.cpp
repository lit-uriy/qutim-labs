#include "toolframewindow_p.h"
#include <QLibrary>
#include <QStyle>
#include <QFrame>

typedef HRESULT (WINAPI * DwmDefWindowProc_t)(HWND, UINT, WPARAM, LPARAM, long*);
DwmDefWindowProc_t dwmDefWindowProc = 0;

ToolFrameWindow::ToolFrameWindow(int flags) :
	d_ptr(new ToolFrameWindowPrivate(this))
{
	Q_D(ToolFrameWindow);
	if (!dwmDefWindowProc) {
		QLibrary dwmapi("dwmapi");
		dwmDefWindowProc = reinterpret_cast<DwmDefWindowProc_t>(dwmapi.resolve("DwmDefWindowProc"));
	}
	d->flags = flags;
	d->loadThemeParams();

	int size = style()->pixelMetric(QStyle::PM_SmallIconSize);
	d->iconSize = QSize(size, size);

	d->vLayout = new QVBoxLayout(this);
	d->hLayout = new QHBoxLayout();
	d->vLayout->addLayout(d->hLayout);

	d->spacerItem = new QSpacerItem(0, d->captionHeight + d->verticalBorder, QSizePolicy::Expanding, QSizePolicy::Fixed);
	d->hLayout->addSpacerItem(d->spacerItem);

	d->vLayout->setContentsMargins(d->verticalBorder, 0, d->verticalBorder, d->horizontalBorder);
	d->hLayout->setSpacing(0);
	d->vLayout->setSpacing(0);
	d->_q_do_layout();
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
	btn->setIconSize(d->iconSize);
	d->buttonHash.insert(action, btn);
	addWidget(btn, Qt::AlignVCenter);
}

void ToolFrameWindow::removeWidget(QWidget *widget)
{
	Q_D(ToolFrameWindow);
	d->hLayout->removeWidget(widget);
	d->_q_do_layout();
}

void ToolFrameWindow::removeAction(QAction *action)
{
	Q_D(ToolFrameWindow);
	QWidget::removeAction(action);
	d->buttonHash.take(action)->deleteLater();
	d->_q_do_layout();
}

void ToolFrameWindow::addWidget(QWidget *widget, Qt::Alignment aligment)
{
	Q_D(ToolFrameWindow);
	d->hLayout->insertWidget(d->hLayout->count() - 1, widget, 0, aligment);
	d->_q_do_layout();
	connect(widget, SIGNAL(destroyed()), this, SLOT(_q_do_layout()));
}

void ToolFrameWindow::setCentralWidget(QWidget *widget)
{
	Q_D(ToolFrameWindow);
	if (d->centralWidget)
		layout()->removeWidget(d->centralWidget);
	d->centralWidget = widget;
	d->centralWidget->winId();
	layout()->addWidget(widget);
	d->_q_do_layout();
}

void ToolFrameWindow::setIconSize(const QSize &size)
{
	Q_D(ToolFrameWindow);
	d->iconSize = size;
	d->updateButtons();
}

QSize ToolFrameWindow::iconSize() const
{
	return d_func()->iconSize;
}

bool ToolFrameWindow::winEvent(MSG *msg, long *result)
{
	//return QWidget::winEvent(msg, result); //Viv почему кнопки не жмакаются?
	Q_D(ToolFrameWindow);
	if (!QtWin::isCompositionEnabled())
		return QWidget::winEvent(msg, result);

	if (dwmDefWindowProc(msg->hwnd, msg->message, msg->wParam, msg->lParam, result))
		return true;

	switch (msg->message) {
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

QWidget *ToolFrameWindow::addSeparator()
{
	QFrame *frame = new QFrame(this);
	frame->setLineWidth(1);
	frame->setMinimumSize(d_func()->iconSize.width() / 2,
						  d_func()->iconSize.height() * 0.75);
	frame->setFrameShape(QFrame::VLine);
	frame->setFrameShadow(QFrame::Plain);

	QPalette palete = frame->palette();
	palete.setColor(QPalette::WindowText,
					palete.color(QPalette::Shadow));
	frame->setPalette(palete);

	addWidget(frame, Qt::AlignCenter);
	return frame;
}

#include "moc_toolframewindow.cpp"
