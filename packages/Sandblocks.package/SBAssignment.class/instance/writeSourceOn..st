converting
writeSourceOn: aStream

	aStream nextPut: $(.
	binding writeSourceOn: aStream.
	aStream nextPutAll: ' := '.
	value writeSourceOn: aStream.
	aStream nextPut: $)