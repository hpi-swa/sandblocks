formatting
writeSourceOn: aStream

	aStream nextPutAll: '^ '.
	self submorphs second writeSourceOn: aStream