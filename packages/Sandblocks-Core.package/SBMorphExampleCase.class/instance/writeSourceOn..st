printing
writeSourceOn: aStream

	aStream nextPutAll: '(SBMorphExampleCase name: '.
	nameInput contents storeOn: aStream.
	aStream nextPutAll: ' caseBlock: '.
	self caseBlock writeSourceOn: aStream.
	aStream nextPut: $)