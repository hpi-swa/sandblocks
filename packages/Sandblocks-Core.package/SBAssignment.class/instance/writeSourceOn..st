converting
writeSourceOn: aStream

	aStream nextPut: $(.
	self binding writeSourceOn: aStream.
	aStream nextPutAll: ' := '.
	self expression writeSourceOn: aStream.
	aStream nextPut: $)