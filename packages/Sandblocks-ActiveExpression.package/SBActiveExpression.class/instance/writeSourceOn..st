printing
writeSourceOn: aStream

	aStream nextPutAll: '(SBSynchronousActiveExpression on: '.
	self block writeSourceOn: aStream.
	aStream nextPut: $)