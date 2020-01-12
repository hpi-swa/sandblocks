as yet unclassified
storeOn: aStream

	aStream
		nextPut: $);
		nextPutAll: self className;
		nextPutAll: ' newFor: ';
		nextPutAll: self shownClass name;
		nextPutAll: ' at: '.
	self position storeOn: aStream.
	aStream nextPut: $)