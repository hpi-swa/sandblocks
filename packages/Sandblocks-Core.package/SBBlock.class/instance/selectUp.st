actions
selectUp
	<multiSelectAction>
	<inputAction>

	self sandblockEditor mode = #input ifTrue: [^ self sandblockEditor endInput].
	
	self parentSandblock ifNotNil: [:b |
		self sandblockEditor selectionDownHistory addLast: self.
		b select]