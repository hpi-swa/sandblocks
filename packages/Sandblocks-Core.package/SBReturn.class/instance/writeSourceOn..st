formatting
writeSourceOn: aStream

	aStream nextPutAll: '^ '.
	self expression writeSourceOn: aStream