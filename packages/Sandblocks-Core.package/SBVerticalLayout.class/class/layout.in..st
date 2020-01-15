as yet unclassified
layout: aMorph in: aRectangle

	| y |
	y := aRectangle top.
	self layoutMorphsOf: aMorph do: [:m | | extent |
		extent := m minExtent.
		m layoutInBounds: (aRectangle left @ y extent: extent).
		y := y + extent y + aMorph cellGap]