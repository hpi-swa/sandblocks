as yet unclassified
minExtentOf: aMorph in: aRectangle

	| minHeight totalWidth count |
	minHeight := 0.
	totalWidth := 0.
	count := self layoutMorphsOf: aMorph do: [:m | | extent |
		extent := m minExtent.
		minHeight := extent y max: minHeight.
		totalWidth := totalWidth + extent x].
	
	^ (totalWidth + (count - 1 * aMorph cellGap)) @ minHeight