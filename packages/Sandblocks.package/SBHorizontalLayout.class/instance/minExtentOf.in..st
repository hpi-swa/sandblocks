as yet unclassified
minExtentOf: aMorph in: aRectangle

	| minHeight totalWidth |
	minExtentCache ifNotNil: [^ minExtentCache].
	
	minHeight := 0.
	totalWidth := 0.
	aMorph submorphsDo: [:m | | extent |
		extent := m minExtent.
		minHeight := extent y max: minHeight.
		totalWidth := totalWidth + extent x].
	
	^ minExtentCache := (totalWidth + (aMorph submorphCount - 1 * aMorph cellGap)) @ minHeight