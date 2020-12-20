as yet unclassified
printOn: aStream

	aStream
		nextPutAll: 'method category ';
		nextPutAll: self firstSubmorph contents