as yet unclassified
step

	cursorShown := cursorShown not.
	self morph invalidRect: (self morph outerBounds expandBy: 4).
	blinkCount := blinkCount + 1.
	blinkCount > self maxBlickCount ifTrue: [self morph updateSteppingDecorators]