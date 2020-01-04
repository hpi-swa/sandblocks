as yet unclassified
writeSourceOn: aStream

	aStream nextPut: $(.
	indicator color printOn: aStream.
	aStream nextPut: $)