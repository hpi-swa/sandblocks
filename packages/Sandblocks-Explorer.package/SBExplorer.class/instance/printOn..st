as yet unclassified
printOn: aStream

	aStream nextPutAll: 'explorer on '.
	aStream nextPutAll: (self object printStringLimitedTo: 40)