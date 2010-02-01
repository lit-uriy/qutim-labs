import Qt 4.6

Item {
	id: wrapper
	signal successed
	signal failed
	property var sid : ""
	Column {
		anchors.centerIn: parent
		spacing: 20
		Column{
			spacing: 4
			Text {
				text: qsTr("Email:")
				font.pixelSize: 16; font.bold: true; color: "white"; style: Text.Raised; styleColor: "black"
				horizontalAlignment: Qt.AlignRight
			}
			Item {
				width: 220
				height: 28
				BorderImage { source: "images/lineedit.sci"; anchors.fill: parent }
				TextInput{
					id: emailIn
					text: login.email
					width: parent.width - 8
					anchors.centerIn: parent
					font.pixelSize: 16;
					font.bold: true
					color: "#151515"; selectionColor: "green"
					KeyNavigation.down: passIn
					focus: true
				}
			}
		}
		Column{
			spacing: 4
			Text {
				text: qsTr("Password:")
				font.pixelSize: 16; font.bold: true; color: "white"; style: Text.Raised; styleColor: "black"
				horizontalAlignment: Qt.AlignRight
			}
			Item {
				width: 220
				height: 28
				BorderImage { source: "images/lineedit.sci"; anchors.fill: parent }
				TextInput{
					id: passIn
					text: login.password
					width: parent.width - 8
					anchors.centerIn: parent
					echoMode: TextInput.Password
					font.pixelSize: 16;
					font.bold: true
					color: "#151515"; selectionColor: "green"
					KeyNavigation.down: loginBtn
					KeyNavigation.up: emailIn
				}
			}
		}
		Row{
			spacing: 10
			Button {
				width: 220
				height: 32
				id: loginBtn
				keyUsing: true;
				text: qsTr("Login")
				KeyNavigation.up: passIn
				Keys.onReturnPressed: loginBtn.doLogin();
				Keys.onSelectPressed: loginBtn.doLogin();
				Keys.onSpacePressed: loginBtn.doLogin();
				onClicked: loginBtn.doLogin();
				function doLogin() {
					login.email = emailIn.text;
					login.password = passIn.text;
					login.doForceLogin();
				}
				Connection {
					sender: wrapper
					signal: "successed"
					script: loginBtn.text = "Login";
				}
				Connection {
					sender: wrapper
					signal: "failed"
					script: loginBtn.text = "login failed";
				}
			}
		}
	}
	Item {
		id:login
		property var email : ""
		property var password : ""
		property int siteId : 2
		function doForceLogin(){
			if (!email && !password) {
				wrapper.failed();
				return;
			}
			var doc = new XMLHttpRequest();
			doc.onreadystatechange = function() {
				if (doc.readyState == XMLHttpRequest.DONE) {
					var sid = doc.getResponseHeader("location").match(/sid=(.*)/i);
					console.log(sid);
					if (sid[1] < 0) {
						wrapper.failed();

					}
					else {
						wrapper.sid = sid[1];
						wrapper.successed();
					}
				}
			}
			var passwd = utf8Encode(password);
			var requestUrl = "http://login.userapi.com/auth?login=force&site=2&email="+ email +"&pass=" + passwd;
			doc.open("GET", requestUrl);
			doc.send();
		}
		function utf8Encode(str) {
			var utftext = "";

			for (var n = 0; n < str.length; n++) {
				var c = str.charCodeAt(n);

				if (c < 128) {
					utftext += '%' + parseInt(c).toString(16);
				}
				else if((c > 127) && (c < 2048)) {
					utftext += '%' + parseInt((c >> 6) | 192).toString(16);
					utftext += '%' + parseInt((c & 63) | 128).toString(16);
				}
				else {
					utftext += '%' + parseInt((c >> 12) | 224).toString(16);
					utftext += '%' + parseInt(((c >> 6) & 63) | 128).toString(16);
					utftext += '%' + parseInt((c & 63) | 128).toString(16);
				}

			}

			return utftext;
		}
	}
	onSuccessed: {
		var db = openDatabaseSync("vk-client-db", "1.0", "Vkontakte client database", 1000000);
		db.transaction(
			function(tx) {
				// Create the database if it doesn't already exist
				tx.executeSql('CREATE TABLE IF NOT EXISTS settings(key TEXT, value TEXT)');
				// Add (another) greeting row
				tx.executeSql('INSERT INTO settings VALUES(?, ?)', [ 'email', login.email ]);
				tx.executeSql('INSERT INTO settings VALUES(?, ?)', [ 'password', login.password ]);
			}
		)
	}
	Component.onCompleted: {
		var db = openDatabaseSync("vk-client-db", "1.0", "Vkontakte client database", 1000000);
		db.transaction(
			function(tx) {
				var rs = tx.executeSql('SELECT * FROM settings');
				var settings = new Array();
				for(var i = 0; i < rs.rows.length; i++) {
					settings[rs.rows.item(i).key] = rs.rows.item(i).value;
				}
				login.password = settings['password'];
				login.email = settings['email'];
			}
		)
	}
}
