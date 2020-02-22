selection
selectUp

	| from |
	from := self selection.
	
	from parentSandblock ifNotNil: [:b |
		selectionDownHistory addLast: self selection.
		self select: b]