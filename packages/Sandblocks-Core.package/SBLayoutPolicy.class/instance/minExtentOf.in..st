as yet unclassified
minExtentOf: aMorph in: aRectangle

	minExtentCache ifNotNil: [^ minExtentCache].
	
	^ minExtentCache := self class minExtentOf: aMorph in: aRectangle