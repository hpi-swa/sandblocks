as yet unclassified
writeSourceOn: aStream

	aStream nextPutAll: '(SBToggledCode comment: '.
	comment contents storeOn: aStream.
	aStream nextPutAll: ' active: '.
	self activeIndex storeOn: aStream.
	aStream nextPutAll: ' do: {'.
	self submorphs allButFirst do: [:row | row lastSubmorph writeSourceOn: aStream] separatedBy: [aStream nextPut: $.].
	aStream nextPutAll: '})'