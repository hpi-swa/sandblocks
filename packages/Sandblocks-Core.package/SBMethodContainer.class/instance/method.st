as yet unclassified
method

	^ self hasSubmorphs ifTrue: [self firstSubmorph] ifFalse: [nil]