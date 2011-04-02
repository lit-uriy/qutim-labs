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
	void addWidget(QWidget *widget);
	void setCentralWidget(QWidget *widget);
protected:
	bool winEvent(MSG *message, long *result);
private:
	QScopedPointer<ToolFrameWindowPrivate> d_ptr;
};


#endif // TOOLFRAMEWINDOW_H
