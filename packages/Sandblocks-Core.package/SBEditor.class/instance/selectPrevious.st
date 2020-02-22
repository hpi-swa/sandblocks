selection
selectPrevious

	| from |
	from := self selection.
	
	selectionDownHistory removeAll.
	from previousBlock ifNotNil: [:b | self select: b]