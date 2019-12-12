as yet unclassified
basicViewportPosition: aPoint

	self transform: (self transform withOffset: aPoint - self position).
	self changed