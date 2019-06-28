as yet unclassified
writeSourceOn: aStream

	aStream nextPutAll: '(SBWatch report: '.
	self expression writeSourceOn: aStream.
	aStream nextPutAll: ' for: #'''.
	self identifier storeOn: aStream.
	aStream nextPutAll: ''')'