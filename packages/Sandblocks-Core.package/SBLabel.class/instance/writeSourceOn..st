as yet unclassified
writeSourceOn: aStream

	aStream
		nextPut: $(;
		nextPutAll: self className;
		nextPutAll: ' text: ['.
	
	((String new: headingLevel withAll: $#), text contents) storeOn: aStream.
	
	aStream nextPutAll: '])'