as yet unclassified
writeSourceOn: aStream

	self firstSubmorph writeSourceOn: aStream.
	aStream space; nextPutAll: self messageSelector asString; space.
	self lastSubmorph writeSourceOn: aStream