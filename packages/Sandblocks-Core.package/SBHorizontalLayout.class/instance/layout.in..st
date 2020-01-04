as yet unclassified
layout: aMorph in: aRectangle

	| x |
	x := aRectangle left.
	self layoutMorphsOf: aMorph do: [:m | | extent |
		extent := m minExtent.
		m layoutInBounds: (x @ (aRectangle top + (aRectangle height - extent y / 2) ceiling) extent: extent).
		x := x + extent x + aMorph cellGap]