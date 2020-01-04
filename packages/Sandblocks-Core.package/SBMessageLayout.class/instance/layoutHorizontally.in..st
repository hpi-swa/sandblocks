as yet unclassified
layoutHorizontally: aMorph in: aRectangle

	 | x maxHeight |
	x := aRectangle left.
	maxHeight := aMorph submorphs inject: 0 into: [:max :morph | max max: morph height].
	aMorph submorphsDo: [:m |
		m layoutInBounds: (x @ ((maxHeight / 2) - (m height / 2) + aRectangle top) extent: m extent).
		x := x + m width]