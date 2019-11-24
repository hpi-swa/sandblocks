as yet unclassified
moveViewport: aPoint

	self transform: (self transform withOffset: transform offset + aPoint negated).
	self changed