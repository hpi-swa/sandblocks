as yet unclassified
storeOn: aStream

	aStream
		nextPut: $(;
		nextPutAll: self className;
		nextPutAll: ' newFor: ';
		nextPutAll: self method methodClass name;
		nextPutAll: ' >> ';
		nextPutAll: self method selector asSymbol storeString;
		nextPutAll: ' at: ';
		nextPutAll: self position storeString;
		nextPut: $)