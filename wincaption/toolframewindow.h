#ifndef TOOLFRAMEWINDOW_H
#define TOOLFRAMEWINDOW_H

#include <QWidget>


class ToolFrameWindowPrivate;
class ToolFrameWindow : public QWidget
{
	Q_OBJECT
	Q_DECLARE_PRIVATE(ToolFrameWindow);
public:
	//enum Flags
	//{

	//};
	explicit ToolFrameWindow();
	virtual ~ToolFrameWindow();
	void addAction(QAction *action);
	void removeAction(QAction *action);
	void addWidget(QWidget *widget, Qt::Alignment = Qt::AlignTop);
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
