as yet unclassified
minExtentOf: aMorph in: aRectangle

	| minWidth totalHeight |
	minWidth := 0.
	totalHeight := 0.
	self layoutMorphsOf: aMorph do: [:m | | extent |
		extent := m minExtent.
		minWidth := extent x max: minWidth.
		totalHeight := totalHeight + extent y].
	
	^ minWidth @ (totalHeight + (aMorph submorphCount - 1 * aMorph cellGap))