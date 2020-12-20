accessing
printOn: aStream

	aStream nextPutAll: lastUsed "relativeP"printString.
	aStream nextPutAll: ' - '.
	aStream nextPutAll: name