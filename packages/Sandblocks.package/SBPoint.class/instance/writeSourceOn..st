as yet unclassified
writeSourceOn: aStream

	self firstSubmorph writeSourceOn: aStream.
	aStream nextPutAll: ' @ '.
	self lastSubmorph writeSourceOn: aStream