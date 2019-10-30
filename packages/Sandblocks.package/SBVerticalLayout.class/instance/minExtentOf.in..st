as yet unclassified
minExtentOf: aMorph in: aRectangle

	| minWidth totalHeight |
	minExtentCache ifNotNil: [^ minExtentCache].
	
	minWidth := 0.
	totalHeight := 0.
	aMorph submorphsDo: [:m | | extent |
		extent := m minExtent.
		minWidth := extent x max: minWidth.
		totalHeight := totalHeight + extent y].
	
	^ minExtentCache := minWidth @ (totalHeight + (aMorph submorphCount - 1 * aMorph cellGap))