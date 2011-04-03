#ifndef TOOLFRAMEWINDOW_H
#define TOOLFRAMEWINDOW_H

#include <QWidget>


class ToolFrameWindowPrivate;
class ToolFrameWindow : public QWidget
{
	Q_OBJECT
	Q_DECLARE_PRIVATE(ToolFrameWindow);
public:
	enum Flags
	{
		DisableExtendFrame = 0x1, //for manual control
	};
	explicit ToolFrameWindow(int flags = 0);
	virtual ~ToolFrameWindow();
	void addAction(QAction *action);
	QWidget *addSeparator();
	void addWidget(QWidget *widget, Qt::Alignment = Qt::AlignTop);
	//void insertAction(QAction *before, QAction *action);
	//QWidget *insertSeparator(QAction *before);
	void removeAction(QAction *action);
	void removeWidget(QWidget *widget);
	void setCentralWidget(QWidget *widget);
	void setIconSize(const QSize &size);
	QSize iconSize() const;
protected:
	bool winEvent(MSG *message, long *result);
private:
	QScopedPointer<ToolFrameWindowPrivate> d_ptr;
	Q_PRIVATE_SLOT(d_func(), void _q_do_layout())
};


#endif // TOOLFRAMEWINDOW_H
