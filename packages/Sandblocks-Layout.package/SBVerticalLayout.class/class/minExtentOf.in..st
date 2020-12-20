as yet unclassified
minExtentOf: aMorph in: aRectangle

	| minWidth totalHeight count |
	minWidth := 0.
	totalHeight := 0.
	count := self layoutMorphsOf: aMorph do: [:m | | extent |
		extent := m minExtent.
		minWidth := extent x max: minWidth.
		totalHeight := totalHeight + extent y].
	
	^ minWidth @ (totalHeight + (count - 1 * aMorph cellGap))