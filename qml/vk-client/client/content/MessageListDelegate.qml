import Qt 4.6

Component {
	Item {
		id: wrapper;
		anchors {
			left:parent.left
			right:parent.right
		}
		height: (body.y + body.height + 15)

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
				source: imagePath
				anchors.centerIn: parent
			}

			anchors.left: wrapper.left
			anchors.leftMargin: 5
			anchors.verticalCenter: parent.verticalCenter
		}
		Text {
			id: body
			text: (name + "<br />" + messageText)
			color: "white"
			font.bold: true
			wrap: true
			style: "Raised"; styleColor: "black"

			anchors.left: avatarBorder.right
			anchors.leftMargin: 10
			anchors.top: avatarBorder.top
			anchors.right: parent.right
			anchors.rightMargin: 10
		}
	}
}
