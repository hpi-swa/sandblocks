as yet unclassified
layout: aMorph in: aRectangle

	| x fontHeight |
	fontHeight := self fontToUse height.
	
	aMorph firstSubmorph
		layoutInBounds: (aRectangle left @ (aRectangle top + (aRectangle height - fontHeight)) extent: aRectangle width @ fontHeight)
		positioning: #topLeft.
	
	x := aRectangle left.
	aMorph submorphs allButFirstDo: [:morph | | width |
		width := ((aRectangle width * morph tally tally) / aMorph tally tally) truncated.
		morph
			layoutInBounds: (x @ aRectangle top extent: (width max: 0) @ (aRectangle height - fontHeight))
			positioning: #bottomLeft.
		x := x + width]