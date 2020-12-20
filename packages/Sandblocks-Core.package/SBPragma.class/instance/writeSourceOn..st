as yet unclassified
writeSourceOn: aStream

	aStream nextPut: $<.
	signature writeSourceOn: aStream.
	aStream nextPut: $>