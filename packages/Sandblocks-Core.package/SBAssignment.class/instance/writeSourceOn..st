converting
writeSourceOn: aStream

	aStream nextPut: $(.
	self submorphs first writeSourceOn: aStream.
	aStream nextPutAll: ' := '.
	self submorphs third writeSourceOn: aStream.
	aStream nextPut: $)