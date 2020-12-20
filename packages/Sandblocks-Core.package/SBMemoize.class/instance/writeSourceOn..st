as yet unclassified
writeSourceOn: aStream

	aStream
		nextPut: $(;
		nextPutAll: self className;
		nextPutAll: ' do: '.
	self expression writeSourceOn: aStream.
	aStream
		nextPutAll: ' identifier: ';
		nextPutAll: self identifier storeString;
		nextPut: $)