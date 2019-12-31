accessing
printOn: aStream

	aStream nextPutAll: lastUsed relativePrintString.
	aStream nextPutAll: ' - '.
	aStream nextPutAll: name