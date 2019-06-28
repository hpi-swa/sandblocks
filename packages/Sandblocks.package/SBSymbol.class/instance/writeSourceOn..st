as yet unclassified
writeSourceOn: aStream

	aStream nextPutAll: '#'.
	self contents asString storeOn: aStream