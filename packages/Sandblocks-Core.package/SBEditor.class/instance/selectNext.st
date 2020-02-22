selection
selectNext

	| from |
	from := self selection.
	
	selectionDownHistory removeAll.
	from nextBlock ifNotNil: [:b | self select: b]