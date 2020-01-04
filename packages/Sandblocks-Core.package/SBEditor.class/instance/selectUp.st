selection
selectUp

	| from |
	from := self selection.
	
	from isCodeContainer
		ifTrue: [self select: (from closestAdjacentFrom: #topCenter to: #bottomCenter)]
		ifFalse: [
			from parentSandblock ifNotNil: [:b |
				selectionDownHistory addLast: self selection.
				self select: b]]