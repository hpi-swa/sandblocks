as yet unclassified
minExtentOf: aMorph in: aRectangle

	minExtentCache ifNotNil: [^ minExtentCache].
	
	^ minExtentCache := (self wantsMultiRow: aMorph)
		ifTrue: [SBVerticalLayout minExtentOf: aMorph in: aRectangle]
		ifFalse: [SBHorizontalLayout minExtentOf: aMorph in: aRectangle]