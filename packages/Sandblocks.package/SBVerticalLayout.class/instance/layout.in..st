as yet unclassified
layout: aMorph in: aRectangle

	| y |
	y := aRectangle top.
	aMorph submorphsDo: [:m | | extent |
		extent := m minExtent.
		m bounds: (aRectangle left @ y extent: extent).
		y := y + extent y + aMorph cellInset]