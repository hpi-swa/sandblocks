as yet unclassified
moveCursor: aNumber selecting: aBoolean

	(self hasSelection and: [aBoolean not]) ifTrue: [
		^ self moveCursorTo: (self betterCursorAfterSelectionTo: aNumber)].
	
	(self canMoveCursorDirection: aNumber) ifTrue: [self cursor: self cursor + aNumber].
	
	aBoolean ifFalse: [self selectionBound: self cursor]