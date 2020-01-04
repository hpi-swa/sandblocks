formatting
writeSourceOn: aStream

	aStream nextPutAll: '^ '.
	self firstSubmorph writeSourceOn: aStream