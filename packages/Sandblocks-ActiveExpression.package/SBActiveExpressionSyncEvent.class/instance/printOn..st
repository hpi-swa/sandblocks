as yet unclassified
printOn: aStream

	aStream nextPutAll: 'marker around '.
	self expression printOn: aStream