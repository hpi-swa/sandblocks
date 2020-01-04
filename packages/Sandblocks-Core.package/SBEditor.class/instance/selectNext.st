selection
selectNext

	| from |
	from := self selection.
	
	from isCodeContainer
		ifTrue: [self select: (from closestAdjacentFrom: #rightCenter to: #leftCenter)]
		ifFalse: [
			selectionDownHistory removeAll.
			from nextBlock ifNotNil: [:b | self select: b]]