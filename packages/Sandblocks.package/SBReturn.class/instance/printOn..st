formatting
printOn: aStream

	aStream nextPutAll: 'return '.
	self submorphs second printOn: aStream