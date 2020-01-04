as yet unclassified
minExtentOf: aMorph in: aRectangle

	| r s |
	minExtentCache ifNotNil: [^ minExtentCache].
	
	aMorph receiver ifNil: [^ minExtentCache := aMorph signature minExtent].
	
	r := aMorph receiver minExtent.
	s := aMorph signature minExtent.
	
	^ minExtentCache := (self wantsMultiRow: aMorph)
		ifTrue: [(r x max: s x + (self indent * aMorph scalingFactor)) @ (r y + s y + (aMorph cellGap * self spaceFactorMultiRow))]
		ifFalse: [(r x + s x + aMorph cellGap) @ (r y max: s y)]