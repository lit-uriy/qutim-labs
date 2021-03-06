#ifndef SIMPLEWIDGET_H
#define SIMPLEWIDGET_H
#include <QMainWindow>
#include <abstractcontactlist.h>
#include <simplecontactlistview.h>
#include <qutim/status.h>

namespace qutim_sdk_0_3
{
class Account;
class Contact;
}

class ToolFrameWindow;
class QPushButton;
class QLineEdit;
class QAction;
namespace Core {
namespace SimpleContactList {

class SimpleWidget : public QWidget, public AbstractContactListWidget
{
	Q_OBJECT
	Q_INTERFACES(Core::SimpleContactList::AbstractContactListWidget)
	Q_CLASSINFO("Service", "ContactListWidget")
	Q_CLASSINFO("Uses", "ContactDelegate")
	Q_CLASSINFO("Uses", "ContactModel")
public:
	SimpleWidget();
	~SimpleWidget();
	void loadGeometry();
	virtual void addButton(ActionGenerator *generator);
	virtual void removeButton(ActionGenerator *generator);
	AbstractContactModel *model() const;
protected:
	QAction *createGlobalStatusAction(Status::Type type);
	bool event(QEvent *event);
private slots:
	void init();
	void onAccountCreated(qutim_sdk_0_3::Account *account);
	void onAccountStatusChanged(const qutim_sdk_0_3::Status &status);
	void onAccountDestroyed(QObject *obj);
	void onStatusChanged();
	void onSearchButtonToggled(bool toggled);
	void showStatusDialog();
	void changeStatusTextAccepted();
	void orientationChanged();
	void save();
private:
	TreeView *m_view;
	AbstractContactModel *m_model;
	QPushButton *m_statusBtn;
	QLineEdit *m_searchBar;
	QHash<Account *, QAction *> m_actions;
	QAction *m_status_action;
	QList<QAction *> m_statusActions;
	ToolFrameWindow *m_toolFrameWindow;
	MenuController *m_controller;
};

} // namespace SimpleContactList
} // namespace Core

#endif // SIMPLEWIDGET_H
