as yet unclassified
writeSourceOn: aStream

	aStream nextPutAll: '(SBToggledCode comment: '.
	comment contents storeOn: aStream.
	aStream nextPutAll: ' active: '.
	active writeSourceOn: aStream.
	aStream nextPutAll: ' do: '.
	self block writeSourceOn: aStream.
	aStream nextPut: $)