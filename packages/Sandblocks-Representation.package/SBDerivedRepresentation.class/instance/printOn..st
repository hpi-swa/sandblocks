as yet unclassified
printOn: aStream

	aStream nextPut: $(.
	aStream nextPutAll: self className.
	aStream space.
	self from printOn: aStream.
	aStream nextPutAll: ' -> '.
	self to printOn: aStream.
	aStream nextPut: $).