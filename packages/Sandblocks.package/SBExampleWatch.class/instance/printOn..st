as yet unclassified
printOn: aStream

	aStream nextPutAll: 'watch '.
	self hasSubmorphs ifTrue: [self expression printOn: aStream]