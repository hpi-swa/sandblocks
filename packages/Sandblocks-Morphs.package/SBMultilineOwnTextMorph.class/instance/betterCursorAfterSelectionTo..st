as yet unclassified
betterCursorAfterSelectionTo: aNumber
	" determine whether to go left or right upon arrow key hits when leaving a selection "
	
	^ ((self selectionBound < self cursor and: [aNumber < 0])
		or: [self selectionBound > self cursor and: [aNumber > 0]])
		ifTrue: [self selectionBound]
		ifFalse: [self cursor]