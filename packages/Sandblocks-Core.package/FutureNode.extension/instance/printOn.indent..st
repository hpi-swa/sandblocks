*Sandblocks-Core
printOn: aStream indent: level

	aStream space; nextPutAll: originalSelector; space; nextPutAll: futureSelector.
	receiver printOn: aStream indent: level