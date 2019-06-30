as yet unclassified
writeSourceOn: aStream

	self hasSubmorphs ifFalse: [^ self].
	
	aStream nextPutAll: '| '.
	self childSandblocks do: [:m | m writeSourceOn: aStream. aStream space].
	aStream nextPutAll: '|'