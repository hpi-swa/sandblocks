as yet unclassified
writeSourceOn: aStream

	self hasSubmorphs ifFalse: [^ self].
	
	aStream nextPutAll: '| '.
	self childSandblocksDo: [:m | m writeSourceOn: aStream. aStream space].
	aStream nextPutAll: '|'