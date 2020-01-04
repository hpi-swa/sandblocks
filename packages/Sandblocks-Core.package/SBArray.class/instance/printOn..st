converting
printOn: aStream

	aStream nextPutAll: 'array of length '.
	aStream nextPutAll: self submorphCount asString