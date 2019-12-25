as yet unclassified
growBy: aPoint

	| grow |
	grow := aPoint sign * 50.
	paintingForm := (Form extent: paintingForm form extent + grow abs depth: 32)
		fillColor: Color white;
		copyBits: paintingForm boundingBox
		from: paintingForm
		at: (grow negated max: 0 @ 0)
		clippingBox: (0 @ 0 extent: paintingForm form extent + grow abs)
		rule: Form over
		fillColor: nil;
		yourself.
	self extent: paintingForm extent.
	
	(grow x < 0 or: [grow y < 0]) ifTrue: [self position: self position + grow]