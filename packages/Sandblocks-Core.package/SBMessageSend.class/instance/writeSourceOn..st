converting
writeSourceOn: aStream

	aStream nextPut: $(.
	self firstSubmorph writeSourceOn: aStream.
	aStream space.
	signature writeSourceOn: aStream.
	aStream nextPut: $)