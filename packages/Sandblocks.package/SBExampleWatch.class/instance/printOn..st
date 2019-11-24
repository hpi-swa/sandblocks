as yet unclassified
printOn: aStream

	aStream nextPutAll: 'example watch '.
	self hasSubmorphs ifTrue: [self expression printOn: aStream]