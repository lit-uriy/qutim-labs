import Qt 4.6

Component {
	Item {
		id: wrapper; width: imageBorder.width; height: imageBorder.height
		Rectangle {
			id: imageBorder
			anchors {
				centerIn: parent
			}
			width: (image.width + 2); height: (image.width + 2);
			color: "white";
			smooth: true

			Image {
				id: image
				height: 110;
				width:110;
				source: previewPath
				anchors.centerIn: parent
				fillMode:Image.PreserveAspectFit
			}
			anchors.left: wrapper.left
			anchors.leftMargin: 5
			anchors.top: parent.top
			anchors.topMargin: 15
		}
	}
}
