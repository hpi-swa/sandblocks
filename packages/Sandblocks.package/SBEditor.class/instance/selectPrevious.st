selection
selectPrevious

	selectionDownHistory removeAll.
	self selection previousBlock ifNotNil: [:b | self select: b]