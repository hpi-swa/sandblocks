printing
writeSourceOn: aStream

	aStream nextPut: $(.
	aStream nextPutAll: self className.
	aStream nextPutAll: ' after: '.
	self expression writeSourceOn: aStream.
	aStream nextPut: $)