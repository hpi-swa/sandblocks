as yet unclassified
writeSourceOn: aStream

	aStream nextPutAll: '(ActiveExpression on: '.
	self block writeSourceOn: aStream.
	aStream nextPut: $)