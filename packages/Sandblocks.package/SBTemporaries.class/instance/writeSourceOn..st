as yet unclassified
writeSourceOn: aStream

	self hasSubmorphs ifFalse: [^ self].
	
	aStream nextPutAll: '| '.
	self submorphsDo: [:m | m writeSourceOn: aStream. aStream space].
	aStream nextPutAll: '|'