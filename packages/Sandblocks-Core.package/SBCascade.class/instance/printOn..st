as yet unclassified
printOn: aStream

	aStream nextPutAll: 'cascade to '.
	self hasSubmorphs ifTrue: [self firstSubmorph printOn: aStream]