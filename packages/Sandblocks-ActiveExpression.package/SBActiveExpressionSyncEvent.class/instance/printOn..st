printing
printOn: aStream

	aStream nextPutAll: 'marker around '.
	self expression printOn: aStream