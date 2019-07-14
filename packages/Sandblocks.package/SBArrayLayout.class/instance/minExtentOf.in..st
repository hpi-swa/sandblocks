as yet unclassified
minExtentOf: aMorph in: aRectangle

	minExtentCache ifNotNil: [^ minExtentCache].
	
	^ minExtentCache := (self wantsMultiRow: aMorph)
		ifTrue: [SBVerticalLayout new minExtentOf: aMorph in: aRectangle]
		ifFalse: [SBHorizontalLayout new minExtentOf: aMorph in: aRectangle]