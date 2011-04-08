import Qt 4.6

ListModel {
	id: clModel
	function indexOf(senderid) {
		for (var i =0; i!=clModel.count; i++) {
			if (clModel.get(i).userid == senderid) {
				return i;
			}
		}
		return -1;
	}
}
