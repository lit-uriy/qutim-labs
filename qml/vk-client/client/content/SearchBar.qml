import Qt 4.6

Item {
	id: searchBar
	property string text: ""
	signal confirmed
	signal cancelled
	signal startEdit

	Script {

		function edit() {
			searchBar.startEdit();
			searchBar.state='editing';
		}

		function confirm() {
			searchBar.text = textEdit.text
			searchBar.state='';
			searchBar.confirmed();
		}

		function reset() {
			textEdit.text = "";
			searchBar.state='';
			searchBar.cancelled();
		}

	}

	height:31

	BorderImage {
		source: "images/addressbar.sci"
		anchors.fill: searchBar
	}

	Image {
		id: cancelIcon
		width: 22
		height: 22
		anchors.right: parent.right
		anchors.rightMargin: 4
		anchors.verticalCenter: parent.verticalCenter
		source: "images/cancel.png"
		opacity: 0
	}

	Image {
		id: confirmIcon
		width: 22
		height: 22
		anchors.left: parent.left
		anchors.leftMargin: 4
		anchors.verticalCenter: parent.verticalCenter
		source: "images/ok.png"
		opacity: 0
	}

	TextInput {
		id: textEdit
		text: searchBar.text
		focus: false
		anchors.left: parent.left
		anchors.leftMargin: 15
		anchors.right: parent.right
		anchors.rightMargin: 0
		anchors.verticalCenter: parent.verticalCenter
		color: "black"
		font.bold: true

		onAccepted: confirm()
		Keys.onEscapePressed: reset()
		onTextChanged: edit()
	}

	MouseRegion {
		anchors.fill: cancelIcon
		onClicked: { reset();/* searchBar.state = "hide" */}
	}

	MouseRegion {
		anchors.fill: confirmIcon
		onClicked: { confirm() }
	}

	MouseRegion {
		id: editRegion
		anchors.fill: textEdit
		onClicked: { edit() }
	}

	states: [
	State {
		name: "editing"
		PropertyChanges {
			target: confirmIcon
			opacity: 1
		}
		PropertyChanges {
			target: cancelIcon
			opacity: 1
		}
		PropertyChanges {
			target: textEdit
			color: "black"
			readOnly: false
			focus: true
			selectionStart: 0
			selectionEnd: -1
		}
		PropertyChanges {
			target: editRegion
			opacity: 0
		}
		PropertyChanges {
			target: textEdit.anchors
			leftMargin: 34
		}
		PropertyChanges {
			target: textEdit.anchors
			rightMargin: 34
		}
	},
	State {
		name: "hide"
		PropertyChanges {
			target:searchBar
			opacity:0
			height:0
		}
	}
	]

	transitions: [
	Transition {
		NumberAnimation {
			matchProperties: "height,opacity,leftMargin,rightMargin"
			duration: 200
		}
		ColorAnimation {
			property: "color"
			duration: 150
		}
	}
	]

}
