as yet unclassified
writeSourceOn: aStream

	aStream nextPut: $(.
	aStream nextPutAll: self className; space.
	aStream nextPutAll: 'self: '.
	self selfBlock writeSourceOn: aStream.
	aStream nextPutAll: ' args: '.
	self argumentsBlock writeSourceOn: aStream.
	aStream nextPut: $)