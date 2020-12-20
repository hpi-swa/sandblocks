as yet unclassified
printOn: aStream

	aStream nextPutAll: self className; nextPut: $(; print: method; nextPut: $,; print: contextIdentityHash; nextPut: $,; print: contextPc; nextPut: $)