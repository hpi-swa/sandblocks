as yet unclassified
writeSourceOn: aStream

	aStream nextPutAll: '(SBExampleWatch report: '.
	self expression writeSourceOn: aStream.
	aStream nextPutAll: ' for: '.
	self identifier storeOn: aStream.
	aStream nextPut: $)