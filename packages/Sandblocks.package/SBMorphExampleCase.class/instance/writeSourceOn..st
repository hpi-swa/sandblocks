as yet unclassified
writeSourceOn: aStream

	aStream nextPutAll: '(SBMorphExampleCase name: '.
	nameInput contents storeOn: aStream.
	aStream nextPutAll: ' caseBlock: '.
	self lastSubmorph writeSourceOn: aStream.
	aStream nextPut: $)