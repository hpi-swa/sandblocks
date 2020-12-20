actions
selectNextSend
	<multiSelectAction>

	self sandblockEditor selectionDownHistory removeAll.
	(self nextBlockThat: #isMessageSend) ifNotNil: #select