as yet unclassified
writeSourceOn: aStream

	aStream nextPutAll: '(Form fromFileNamed: '.
	filename storeOn: aStream.
	aStream nextPut: $)