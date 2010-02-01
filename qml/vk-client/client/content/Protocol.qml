import Qt 4.6

Item { id: wrapper
	property var contactListModel: clModel
	property var messageListModel: msgListModel
	property var photoListModel: pListModel
	property var sid
	//profile data
	property var profileId
	property var firstName: "Loading..."
	property var lastName: "Loading..."
	property var activity
	property var imagePath
	signal loaded
	signal messageAdded
	signal logout
	signal photos

	function loadProfile () {
		var doc = new XMLHttpRequest();
		doc.onreadystatechange = function() {
			if (doc.readyState == XMLHttpRequest.DONE) {
				var profileData = eval ('(' + doc.responseText + ')' ); //mega ugly workaround
				wrapper.profileId = profileData.id;
				wrapper.firstName = profileData.fn;
				wrapper.lastName = profileData.ln;
				wrapper.imagePath = profileData.bp;
				wrapper.getContactList(); //ugly workaround
				wrapper.loaded();
			}
		}
		var requestUrl = "http://userapi.com/data?act=profile&sid=" + wrapper.sid;
		console.log(">>Load profile \n" + requestUrl);
		doc.open("GET", requestUrl);
		doc.send();
	}
	function doLogout () {
		var doc = new XMLHttpRequest();
		var requestUrl = "http://login.userapi.com/auth?​login=logout&site=2&​sid=" + wrapper.sid;
		doc.open("GET", requestUrl);
		doc.send();
	}
	function checkForNewMessages () {
		var doc = new XMLHttpRequest();
		doc.onreadystatechange = function() {
			if (doc.readyState == XMLHttpRequest.DONE) {
				var newMessages = JSON.parse(doc.responseText);
				var messageCount = newMessages.nm;
				if (messageCount>0) {
					msgListModel.unreadMessagesCount = messageCount;
					console.log("Have unread messages>> " + messageCount);
					wrapper.getNewMessages();					
				}
			}
		}
		var requestUrl = "http://userapi.com/data?act=history&sid=" + wrapper.sid;
		console.log(">>Check for new messages \n" + requestUrl);
		doc.open("GET", requestUrl);
		doc.send();
	}
	function getNewMessages () {
		var doc = new XMLHttpRequest();
		doc.onreadystatechange = function() {
			if (doc.readyState == XMLHttpRequest.DONE) {
				var newMessages = JSON.parse(doc.responseText);
				var msgArray = newMessages.inbox.d;
				var tmp = msgArray.pop(); //hack, vkontakte is very strange at times
				wrapper.appendMessages(msgArray);
				wrapper.markMessagesAsReaded();
			}

		}
		var requestUrl = "http://userapi.com/data?act=history&message=&inbox=" + msgListModel.unreadMessagesCount + "&sid=" + wrapper.sid;
		console.log(">>Get new messages \n" + requestUrl);
		doc.open("GET", requestUrl);
		doc.send();
	}
	function appendMessages (msgArray) {
		for (var i = 0;i!=msgArray.lenght;i++) {
			msgListModel.readedMessages = msgListModel.readedMessages + msgArray[i][0] + "_";
			console.log("Append messagy with id " + msgArray[i][0] + " " + msgListModel.indexOf(msgArray[i][0]) );
			if (msgListModel.indexOf(msgArray[i][0]) == -1) {
				var message = 			{
					"msgId" : msgArray[i][0],
					"input" : true,
					"senderid": msgArray[i][3][0],
					"time": msgArray[i][1],
					"imagePath": msgArray[i][3][2],
					"unread": true,
					"messageText": msgArray[i][2][0],
					"name": msgArray[i][3][1]
				};
				msgListModel.append (message);
				wrapper.messageAdded();
			}
		}		
	}
	function getContactList() {
		var doc = new XMLHttpRequest();
		doc.onreadystatechange = function() {
			if (doc.readyState == XMLHttpRequest.DONE) {
				var friends = JSON.parse(doc.responseText);
				wrapper.reloadContactList(friends);
			}
		}
		var requestUrl = "http://userapi.com/data?act=friends&sid=" + wrapper.sid;
		console.log(">>Load friends \n" + requestUrl);
		doc.open("GET", requestUrl);
		doc.send();
	}
	function reloadContactList (items) {
		var friends = items;
		clModel.clear();
		function sOnlineDecrease(i, ii) { // По возрасту (возрастание)
			if (i[3] > ii[3])
				return -1;
			else if (i[3] < ii[3])
				return 1;
			else
				return 0;
		}
		function sNameIncrease(i,ii) {
			if (i[1] > ii[1])
				return 1;
			else if (i[1] < ii[1])
				return -1;
			else
				return 0;
		}
		friends.sort(sNameIncrease);
		friends.sort(sOnlineDecrease);

		for (var i =0; i!=items.length; i++) {
			var contact = 			{
				"userid":friends[i][0],
				"name":friends[i][1],
				"imagePath":friends[i][2],
				"online":friends[i][3],
			};
			clModel.append(contact);
		}
	}
	function sendMessage (userid, body) {
		var doc = new XMLHttpRequest();
		doc.onreadystatechange = function() {
			if (doc.readyState == XMLHttpRequest.DONE) {
				var result = JSON.parse(doc.responseText);
			}

		}
		var requestUrl = "http://userapi.com/data?act=add_message&id=" + userid + "&message="+ body +"&sid=" + wrapper.sid;
		console.log(">>Send message \n" + requestUrl);
		doc.open("GET", requestUrl);
		doc.send();
		var msg = {
			"input" : false,
			"senderid": userid,
			"time": "",
			"imagePath": wrapper.imagePath,
			"unread": false,
			"messageText": body,
			"name": (wrapper.firstName + " " + wrapper.lastName)
		};
		msgListModel.append(msg);
		wrapper.messageAdded();
	}
	function markMessagesAsReaded() {
		var doc = new XMLHttpRequest();
		doc.onreadystatechange = function() {
			if (doc.readyState == XMLHttpRequest.DONE) {
				var tmp = JSON.parse(doc.responseText);
				console.log ("Unreaded messages: " + tmp.nm);
			}
		}
		var requestUrl = "http://userapi.com/data?act=history&read=" + msgListModel.readedMessages + "&sid=" + wrapper.sid;
		console.log(">>Load friends \n" + requestUrl);
		doc.open("GET", requestUrl);
		doc.send();
	}
	function getUserPhotos () {
		var doc = new XMLHttpRequest();
		doc.onreadystatechange = function() {
			if (doc.readyState == XMLHttpRequest.DONE) {
				var photos = JSON.parse(doc.responseText);
				//console.log(photos);
				//appendPhotos(); //WTF? It doesn't work(((
				for (var i=0;i!=photos.length; i++) {
					pListModel.append(
					{
						"itemid" : photos[i][0],
						"previewPath" : photos[i][1],
						"imagePath": photos[i][2]
					}
					);
				}
			}
		}
		var requestUrl = "http://userapi.com/data?act=photos&from=0&to=100000&id=" + pListModel.userid + "&sid=" + wrapper.sid;
		console.log(">>Load photos \n" + requestUrl);
		doc.open("GET", requestUrl);
		doc.send();
	}
	function appendPhotos(items) {

	}
	MsgListModel {
		id: msgListModel		
	}
	ContactListModel {
		id: clModel
	}
	PhotoListModel {
		id: pListModel
	}
	Timer{
		interval: 6000
		running: false
		repeat: true
		id:newMessagesChecker
		onTriggered: {
			wrapper.checkForNewMessages();
		}
	}
	Timer{
		interval: 90000
		running: false
		repeat:true
		id: contactListUpdater
		onTriggered: {
			wrapper.getContactList();
		}

	}
	onLoaded: {
		console.log("Loaded");
		msgListModel.clear();
		//wrapper.checkForNewMessages();
		newMessagesChecker.running = true;
		contactListUpdater.running = true; //ugly method
	}
	onMessageAdded: {
		console.log(">>Readed messages: " + msgListModel.readedMessages);
		var msg_number = (msgListModel.count - 1);
		var item = msgListModel.get(msg_number);
		var index = clModel.indexOf(item.senderid);
		console.log("index" + index + item.senderid);
		if (index == -1) {
			return;
		}
		//		var unreadMessagesCount = (clModel.get(index).haveUnreadMessages + 1);
		//		clModel.set(index,"haveUnreadMessages", unreadMessagesCount);
	}
	onLogout: {
		newMessagesChecker.running = false;
		contactListUpdater.running = false;
	}
}
