as yet unclassified
printOn: aStream

	aStream nextPutAll: 'character '.
	aStream nextPut: (self contents ifNotEmpty: #first ifEmpty: $ )