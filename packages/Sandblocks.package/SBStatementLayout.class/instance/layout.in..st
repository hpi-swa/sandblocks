as yet unclassified
layout: aMorph in: aRectangle

	| y |
	y := 0.
	aMorph submorphsDo: [:m | | h |
		h := m minHeight.
		m layoutInBounds: (aRectangle left @ aRectangle top + y extent: aMorph width @ h).
		y := h + y]