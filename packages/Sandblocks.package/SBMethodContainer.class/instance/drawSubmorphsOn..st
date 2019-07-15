as yet unclassified
drawSubmorphsOn: aCanvas

	super drawSubmorphsOn: aCanvas.
	
	self editor multiSelection do: [:morph |
		aCanvas
			frameRectangle: (morph bounds expandBy: 2) width: 3 * self scalingFactor
			color: ((morph parentSandblock ifNil: [morph]) foregroundColor alpha: 0.6)].
	
	self editor selection ifNotNil: [
		aCanvas
			frameRectangle: (self editor selection bounds expandBy: 2) width: 3 * self scalingFactor
			color: (self editor selection parentSandblock ifNil: [self editor selection]) foregroundColor].
	
	overlayDrawBlocks do: [:block | block value: aCanvas]