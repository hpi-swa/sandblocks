as yet unclassified
printOn: aStream

	aStream nextPutAll: self className; nextPut: $(; nextPutAll: 'left: '; print: self left; nextPutAll: ' right: '; print: self right; nextPutAll: ' top: '; print: self top; nextPutAll: ' bottom: '; print: self bottom; nextPut: $)