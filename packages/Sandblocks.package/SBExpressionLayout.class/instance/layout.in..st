as yet unclassified
layout: aMorph in: aRectangle

	| x |
	x := aRectangle left.
	aMorph submorphsDo: [:m | | extent |
		extent := m minExtent.
		m bounds: (x @ (aRectangle top + (aRectangle height - extent y / 2) rounded) extent: extent).
		x := x + extent x + aMorph cellInset]