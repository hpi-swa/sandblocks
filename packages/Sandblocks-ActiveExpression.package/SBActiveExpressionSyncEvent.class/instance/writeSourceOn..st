as yet unclassified
writeSourceOn: aStream

	aStream nextPut: $(.
	aStream nextPutAll: self className.
	aStream nextPutAll: ' colored: '.
	coloredIndicator color storeOn: aStream.
	aStream nextPutAll: ' after: '.
	self expression writeSourceOn: aStream.
	aStream nextPut: $)