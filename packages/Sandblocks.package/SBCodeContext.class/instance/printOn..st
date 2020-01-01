as yet unclassified
printOn: aStream

	aStream
		nextPutAll: self className;
		nextPut: $(;
		nextPutAll: self stringRepresentation;
		nextPut: $@;
		nextPutAll: pc asString;
		nextPut: $)