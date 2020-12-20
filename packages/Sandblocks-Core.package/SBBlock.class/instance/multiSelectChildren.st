actions
multiSelectChildren
	<multiSelectAction>

	self sandblockEditor mode = #select ifFalse: [self sandblockEditor mode: #selection].
	self childSandblocks do: #startOrAddToMultiSelection