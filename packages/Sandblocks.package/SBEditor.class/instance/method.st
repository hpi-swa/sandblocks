as yet unclassified
method

	^ self selection ifNotNil: #containingMethod ifNil: [self methods first]