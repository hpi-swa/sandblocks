converting
printOn: aStream

	aStream nextPutAll: 'assignment to '.
	aStream nextPutAll: self firstSubmorph contents