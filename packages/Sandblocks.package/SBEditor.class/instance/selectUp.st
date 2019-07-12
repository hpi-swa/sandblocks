selection
selectUp

	self selection parentSandblock ifNotNil: [:b |
		selectionDownHistory addLast: self selection.
		self select: b]