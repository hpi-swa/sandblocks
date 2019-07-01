selection
selectUp

	selectionDownHistory addLast: self selection.
	self selection parentSandblock ifNotNil: [:b | self select: b]