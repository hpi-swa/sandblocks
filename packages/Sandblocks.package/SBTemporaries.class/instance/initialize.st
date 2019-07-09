as yet unclassified
initialize

	super initialize.
	
	self layoutInset: (Rectangle
		left: 4 * self scalingFactor
		right: 4 * self scalingFactor
		top: 2 * self scalingFactor
		bottom: 2 * self scalingFactor)