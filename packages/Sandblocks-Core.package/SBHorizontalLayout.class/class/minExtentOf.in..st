as yet unclassified
minExtentOf: aMorph in: aRectangle

	| minHeight totalWidth |
	minHeight := 0.
	totalWidth := 0.
	self layoutMorphsOf: aMorph do: [:m | | extent |
		extent := m minExtent.
		minHeight := extent y max: minHeight.
		totalWidth := totalWidth + extent x].
	
	^ (totalWidth + (aMorph submorphCount - 1 * aMorph cellGap)) @ minHeight