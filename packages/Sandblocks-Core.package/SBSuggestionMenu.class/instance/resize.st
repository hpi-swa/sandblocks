as yet unclassified
resize

	self extent: (self hasSubmorphs ifFalse: [0 @ 0] ifTrue: [self minExtent])