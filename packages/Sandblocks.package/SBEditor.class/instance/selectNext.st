selection
selectNext

	selectionDownHistory removeAll.
	self selection nextBlock ifNotNil: [:b | self select: b]