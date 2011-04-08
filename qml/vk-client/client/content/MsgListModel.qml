import Qt 4.6

ListModel {
	id: model
	property var unreadMessagesCount: 0
	property var readedMessages: ""
	function indexOf(msgId) {
		for (var i =0; i!=clModel.count; i++) {
			if (model.get(i).msgId == msgId) {
				return i;
			}
		}
		return -1;
	}
}
