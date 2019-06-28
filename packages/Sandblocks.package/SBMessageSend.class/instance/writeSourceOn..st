converting
writeSourceOn: aStream

	aStream nextPut: $(.
	receiver writeSourceOn: aStream.
	aStream space.
	signature writeSourceOn: aStream.
	aStream nextPut: $)