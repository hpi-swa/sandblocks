printing
writeSourceOn: aStream

	aStream nextPutAll: '(SBMorphExample setUp: ['.
	self setUpMorph writeSourceOn: aStream.
	aStream nextPutAll: '] cases: '.
	(SBArray withContents: self cases veryDeepCopy) writeSourceOn: aStream.
	aStream nextPutAll: ' extent: '.
	view extent storeOn: aStream.
	aStream nextPut: $)