actions
selectPreviousSend
	<multiSelectAction>

	self sandblockEditor selectionDownHistory removeAll.
	(self previousBlockThat: #isMessageSend) ifNotNil: #select