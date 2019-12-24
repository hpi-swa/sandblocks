selection
selectPrevious

	| from |
	from := self selection.
	
	from isCodeContainer
		ifTrue: [self select: (from closestAdjacentFrom: #leftCenter to: #rightCenter)]
		ifFalse: [
			selectionDownHistory removeAll.
			from previousBlock ifNotNil: [:b | self select: b]]