converting
multiSelectChildren
	<multiSelectAction>

	self sandblockEditor mode = #select ifFalse: [self sandblockEditor mode: #selection].
	self statements do: #startOrAddToMultiSelection