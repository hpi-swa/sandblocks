as yet unclassified
writeSourceOn: aStream

	aStream nextPutAll: '(SBNewWatch report: '.
	self expression writeSourceOn: aStream.
	aStream nextPutAll: ' for: '.
	self identifier storeOn: aStream.
	aStream nextPut: $)