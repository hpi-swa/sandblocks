compilation cue protocol
writeSourceOn: aStream

	self body writeSourceOn: aStream.
	aStream nextPutAll: ' value'