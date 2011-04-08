import Qt 4.6
import "content" as Vkontakte

Item {
	width: 300
	height: 800
	id: screen
	Rectangle {
		id: background
		anchors.fill: parent; color: "#343434";
		
		Image { source: "content/images/stripes.png"; fillMode: Image.Tile; anchors.fill: parent; opacity: 0.3 }
		
		Vkontakte.Protocol {
			id: protocol
			Connection {
				sender: authView
				signal: "successed"
				script: {
					protocol.sid = authView.sid;
					protocol.loadProfile();
				}
			}
		}
		Vkontakte.ContactListModel {
			id: clProxyModel
			function addItem (index) {
				if (index == -1) {
					return;
				}
				var item = protocol.contactListModel.get(index);
				clProxyModel.append(
				{
					"userid":item.userid,
					"name":item.name,
					"imagePath":item.imagePath,
					"online":item.online,
				}
				);
			}
		}
		Vkontakte.MsgListModel {
			id: chatProxyModel
			property var senderid : 0
			property var sendername
			function addItem (index) {				
				if (index == -1) {
					return;
				}
				var item = protocol.messageListModel.get(index);
				console.log("Item: " + item.name + " "  + item.messageText + " " + item.unread);
				if (item.senderid == chatProxyModel.senderid) {
					chatProxyModel.markAsRead(index);
				}
				chatProxyModel.append(
				{
					"input" : item.input,
					"senderid": item.senderid,
					"time": item.time,
					"imagePath": item.imagePath,
					"unread": item.unread,
					"messageText": item.messageText,
					"name": item.name
				}
				);
			}
			function markAsRead (index) {
				//workaround
				if ((index == -1) || (!protocol.messageListModel.get(index).unread)) {
					return;
				}
				console.log("Marked as read" + protocol.messageListModel.get(index).name);
				protocol.messageListModel.set(index,"unread",false);
				var count = protocol.messageListModel.unreadMessagesCount;
				protocol.messageListModel.unreadMessagesCount = (count > 0) ? (count -1) : 0;
				console.log("Unreaded:" + protocol.messageListModel.unreadMessagesCount);
			}
		}

		Item {
			id: views
			width: parent.width
			anchors.top: titleBar.bottom
			anchors.bottom: toolBar.top

			Vkontakte.AuthView{
				id: authView
				anchors.centerIn: parent
				width: parent.width
				opacity: 0
			}
			resources: [
				Component {
					id: contactListDelegate
					Item {
						property var statuses : [qsTr("offline"),qsTr("online")]
						id: wrapper;
						anchors {
							left:parent.left
							right:parent.right
						}
						height: (avatar.y + avatar.height + 15) //MEGAHACK

						Rectangle {
							color: "black"
							opacity: index % 2 ? 0.2 : 0.3
							height: wrapper.height
							width: wrapper.width
							y: 1
						}

						Rectangle {
							id: avatarBorder
							width: (avatar.width + 2); height: (avatar.height + 2);
							color: "white";
							smooth: true

							Image {
								id: avatar
								width: 32; height: 32
								//fillMode:PreserveAspectCrop
								source: imagePath
								anchors.centerIn: parent
							}

							anchors.left: wrapper.left
							anchors.leftMargin: 5
							anchors.verticalCenter: parent.verticalCenter
						}

						//						Image {
						//							id: avatarBorder
						//							width: 48;
						//							height: 48;
						//							fillMode:Image.PreserveAspectFit
						//							source: imagePath
						//							anchors.left: wrapper.left
						//							anchors.leftMargin: 5
						//							anchors.verticalCenter: parent.verticalCenter
						//						}
						Text {
							text: name
							color: "white"
							font.bold: true
							style: "Raised"; styleColor: "black"

							anchors.left: avatarBorder.right
							anchors.leftMargin: 10
							anchors.top: avatarBorder.top
						}
						Text {
							id: contactStatus
							text: wrapper.statuses[online]
							color: "#CCC"
							font.bold: true
							style: "Raised"; styleColor: "black"

							anchors.left: avatarBorder.right
							anchors.leftMargin: 10
							anchors.bottom: avatarBorder.bottom
						}
						MouseRegion {
							anchors.fill: wrapper
							onClicked: {								
								chatProxyModel.senderid = userid;
								chatProxyModel.sendername = name;
								chatProxyModel.clear();
								for (var i=0;i!=protocol.messageListModel.count;i++) {
									var item = protocol.messageListModel.get(i);
									if ((item.senderid == chatProxyModel.senderid)) {
										console.log ("Item:"+ item.senderid +" "  +item.name +" "+ item.messageText + " " + item.unread );
										chatProxyModel.addItem(i);
										//chatProxyModel.markAsRead(i);
									}
								}
							}
						}
					}
				}

			]
			ListView {
				id: mainView; model: protocol.contactListModel; delegate: contactListDelegate;
				width: parent.width; x: 0; cacheBuffer: 100;
				anchors.top: parent.top
				anchors.bottom: parent.bottom
			}
			ListView {
				id: clProxyView
				model: clProxyModel
				delegate: contactListDelegate
				width: parent.width
				anchors.top: parent.top
				anchors.bottom:parent.bottom
				opacity:0
				x:width * 1.5
			}
			Vkontakte.SearchBar {
				id: userSearch
				anchors.bottom: parent.bottom
				height: 32
				opacity: 1
				z: 10
				anchors.left: parent.left
				anchors.right: parent.right
				state: "hide"
				onConfirmed: {
					clProxyModel.clear();
					console.log("Search >> " + userSearch.text);
					for (var i=0;i!=protocol.contactListModel.count;i++) {
						if (protocol.contactListModel.get(i).name.search(userSearch.text) != -1) {
							clProxyModel.addItem(i);
						}
					}
					background.state = "search";
				}
				onCancelled: {
					clProxyModel.clear();
					background.state = "";
				}
			}
			Flipable {
				id: userSession
				property int angle: 0
				width: parent.width
				x: (screen.width * 1.5)
				anchors {
					top: parent.top
					bottom: parent.bottom
				}
				transform: Rotation {
					id: rotation
					//origin.x: (userSession.width/2); origin.y: (userSession.height/2)
					axis.x: 0; axis.y: 1; axis.z: 0     // rotate around y-axis
					angle: userSession.angle
				}
				Vkontakte.MessageListDelegate {id: messageListDelegate}
				Vkontakte.PhotoGridDelegate{id:photoDelegate}
				front: Item {
					id: chat
					anchors.fill: parent.fill
					width: parent.width
					height:parent.height
					ListView {
						id: chatView;
						model: chatProxyModel
						delegate: messageListDelegate
						width: parent.width
						anchors.top: parent.top
						anchors.bottom: messageInput.top
					}
					Item {
						id: messageInput
						width: parent.width
						height: 150
						Rectangle {
							color: "black"
							opacity: 0.5
							anchors.fill: parent
						}
						anchors {
							bottom: parent.bottom
						}
						Text {
							id: msgInputTitle
							text: qsTr("You message (ctrl+enter to send):")
							font.bold: true; color: "White"
							font.pixelSize: 12
							anchors {
								top: parent.top
								topMargin: 5
								left: parent.left
								leftMargin: 15
								right: parent.right
							}
						}
						TextEdit {
							id: msgEditField
							anchors {
								top: msgInputTitle.bottom
								left: msgInputTitle.left
								right: msgInputTitle.right
								bottom: parent.bottom
								topMargin: 10
								rightMargin: 15
							}
							focus: false
							wrap: true
							width:parent.width
							text: ""
							font.bold: true; color: "White"
							font.pixelSize: 12
							Keys.onPressed: {
								//TODO normal scan code
								if (event.key == 16777220) { //ololo Onotole otake
									if (msgEditField.text != "") {
										protocol.sendMessage(chatProxyModel.senderid,msgEditField.text);
										msgEditField.text = "";
									}
								}
							}
						}
					}
				}
				back: Item {
					id:photos
					anchors {
						top: parent.top
						bottom: parent.bottom
						left: parent.left
						right:parent.right
					}
					GridView {
						id: photoGridView; model: protocol.photoListModel;
						delegate: photoDelegate; cacheBuffer: 100
						cellWidth: 120; cellHeight: 120;
						anchors {
							top: parent.top
							bottom: parent.bottom
							left: parent.left
							right:parent.right
							rightMargin: 20
							leftMargin: 20
						}
					}
				}
				states: [
					State {
						name: "showPhoto"
						PropertyChanges { target: userSession; angle: 180 }
						PropertyChanges { target: showPhotosBtn; opacity: 0 }
						PropertyChanges { target: backPhotosBtn; opacity: 1 }
						PropertyChanges { target: sendBtn; opacity: 0 }
					}
				]
				transitions: [
					Transition { NumberAnimation { matchProperties: "angle"; duration: 1000; easing: "easeInOutQuad" } }
				]
			}
			Connection {
				sender: protocol
				signal: "messageAdded"
				script: {
					//HACK
					var msg_number = (protocol.messageListModel.count - 1);
					var item = protocol.messageListModel.get(msg_number);					
					if (item.senderid == chatProxyModel.senderid) {
						//workaround O.o
						chatProxyModel.markAsRead(msg_number);
						chatProxyModel.append(
						{
							"input" : item.input,
							"senderid": item.senderid,
							"time": item.time,
							"imagePath": item.imagePath,
							"unread": item.unread,
							"messageText": item.messageText,
							"name": item.name
						}
						);
					}
					console.log("Add "+ msg_count + " " +item + " " + item.unread);
					if (item.unread && (background.state != "search") && (clProxyModel.indexOf(item.senderid) == -1)) {
						var index = contactListModel.indexOf(item.senderid);						
						clProxyModel.addItem(index);
					}					
				}
			}
		}
		Vkontakte.ToolBar {
			id: titleBar
			width: parent.width;
			height: 40

			anchors.top: parent.top

			Text {
				id: headerMsg
				anchors {
					left: parent.left; leftMargin: 10;
					verticalCenter: parent.verticalCenter
				}
				elide: Text.ElideLeft
				text: (qsTr("Hello, ") + protocol.firstName)
				font.bold: true; color: "White"; style: Text.Raised; styleColor: "Black"
				font.pixelSize: 12
			}
			Vkontakte.Button {
				id: markBtn
				text: qsTr("Mark all as read")
				opacity: 0

				anchors.right: parent.right
				anchors.top: parent.top
				anchors.bottom: parent.bottom
				anchors.rightMargin: 3
				anchors.topMargin: 3
				anchors.bottomMargin: 3

				textMargin: 20
				onClicked: {
					for (var i=0;i!=protocol.messageListModel.count;i++) {
						chatProxyModel.markAsRead(i);
					}
				}

			}
			Vkontakte.Button {
				id: showPhotosBtn
				text: qsTr("Show photos")
				opacity: 0

				anchors.right: parent.right
				anchors.top: parent.top
				anchors.bottom: parent.bottom
				anchors.rightMargin: 3
				anchors.topMargin: 3
				anchors.bottomMargin: 3

				textMargin: 20
				onClicked: {
					protocol.photoListModel.clear();
					protocol.photoListModel.userid = chatProxyModel.senderid;
					protocol.getUserPhotos();
					//hack
					rotation.origin.x = screen.width/2;
					rotation.origin.y = screen.height/2;
					userSession.state = "showPhoto";
				}
			}
			Vkontakte.Button {
				id: backPhotosBtn
				text: qsTr("Back")
				opacity: 0

				anchors.right: parent.right
				anchors.top: parent.top
				anchors.bottom: parent.bottom
				anchors.rightMargin: 3
				anchors.topMargin: 3
				anchors.bottomMargin: 3

				textMargin: 20
				onClicked: {
					//hack
					rotation.origin.x = screen.width/2;
					rotation.origin.y = screen.height/2;
					userSession.state = "";					
				}
			}
		}
		Vkontakte.ToolBar {
			id: toolBar
			opacity: 0.9
			height: 40

			anchors.bottom: parent.bottom
			anchors.right: parent.right
			anchors.left: parent.left

			Vkontakte.Button {
				id: logoutBtn
				text: qsTr("Logout")

				anchors.right: parent.right
				anchors.top: parent.top
				anchors.bottom: parent.bottom
				anchors.rightMargin: 3
				anchors.topMargin: 3
				anchors.bottomMargin: 3

				textMargin: 20
				onClicked: {
					authView.sid="";
					protocol.doLogout();
				}

			}
			Vkontakte.Button {
				id: searchBtn
				text: qsTr("Search")

				anchors.left: parent.left
				anchors.top: parent.top
				anchors.bottom: parent.bottom
				anchors.rightMargin: 3
				anchors.topMargin: 3
				anchors.bottomMargin: 3
				onClicked: {
					if (userSearch.state == "hide") {
						userSearch.state = "editing";
					}
					else {
						userSearch.state = "hide";
						background.state = "";
					}
				}
			}
			Vkontakte.Button {
				id: backBtn
				text: qsTr("Back")
				opacity: 0

				anchors.left: parent.left
				anchors.top: parent.top
				anchors.bottom: parent.bottom
				anchors.rightMargin: 3
				anchors.topMargin: 3
				anchors.bottomMargin: 3

				textMargin: 20
				onClicked: {
					console.log("unread count: " + protocol.messageListModel.unreadMessagesCount);
					chatProxyModel.senderid = 0;
					protocol.photoListModel.clear();
				}

			}
			Vkontakte.Button {
				id: sendBtn
				text: qsTr("Send")
				opacity: 0

				anchors.right: parent.right
				anchors.top: parent.top
				anchors.bottom: parent.bottom
				anchors.rightMargin: 3
				anchors.topMargin: 3
				anchors.bottomMargin: 3

				textMargin: 20
				onClicked: {
					if (msgEditField.text != "") {
						protocol.sendMessage(chatProxyModel.senderid,msgEditField.text);
						msgEditField.text = "";
					}
				}

			}
		}
		states: [
			State {
				name: "unauthed"; when: authView.sid==""
				PropertyChanges { target: authView; opacity: 1}
				PropertyChanges { target: mainView; opacity: 0}
				PropertyChanges { target: titleBar; opacity: 0; height: 0}
				PropertyChanges { target: toolBar; opacity: 0; height: 0}
				PropertyChanges {target: userSearch; state:"hide"}
				},
				State {
					name: "chat"; when: chatProxyModel.senderid != 0
					PropertyChanges {target: mainView; x: -1.5*screen.width;}
					PropertyChanges {target: userSession; x:0;}
					PropertyChanges {target: backBtn; opacity:1}
					PropertyChanges {target: logoutBtn; opacity:0}
					PropertyChanges {target: sendBtn; opacity:1}
					PropertyChanges {target: searchBtn; opacity:0}
					PropertyChanges {target: userSearch; state:"hide"}
					PropertyChanges {target: msgEditField;focus: true}
					PropertyChanges {target: headerMsg;text: qsTr("Chat with ") + chatProxyModel.sendername}
					PropertyChanges {target: showPhotosBtn; opacity:1;}
					},
					State {
						name: "haveUnreadMessages"; when: (protocol.messageListModel.unreadMessagesCount>0)
						PropertyChanges {target: markBtn; opacity:1;}
						PropertyChanges {target: mainView; x: -1.5*screen.width;opacity:0}
						PropertyChanges {target: clProxyView; x:0;opacity:1}
						PropertyChanges {target: headerMsg;text: qsTr("Unread Messages from:")}
						PropertyChanges {target: searchBtn; opacity:0}
						PropertyChanges {target: userSearch; state:"hide"}
						StateChangeScript {
							script: {
								clProxyModel.clear();
								for (var i = 0;i!=protocol.messageListModel.count;i++) {
									var item = protocol.messageListModel.get(i);
									if (item.unread && (clProxyModel.indexOf(item.senderid) == -1)) {
										var index = protocol.contactListModel.indexOf(item.senderid);
										clProxyModel.addItem(index);
									}
								}
							}
						}
						},
						State {
							name: "search";
							PropertyChanges {target: mainView; x: -1.5*screen.width;opacity:0}
							PropertyChanges {target: clProxyView; x:0;opacity:1}
							PropertyChanges {target: headerMsg;text: qsTr("Looking for ") + userSearch.text}
						}
		]
		transitions: [
			Transition { NumberAnimation { matchProperties: "x,opacity,height"; duration: 500; easing: "easeInOutQuad" } }
		]
	}
}
