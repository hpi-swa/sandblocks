as yet unclassified
storeOn: aStream

	SBExample self: [SBRepl newFromSource: '5 + 5 squared' named: 'REPL'] args: [{'' writeStream}] label: 'simple'.
	aStream nextPut: $(.
	aStream nextPutAll: self className.
	aStream nextPutAll: ' newFromSource: '.
	self body prettySourceString storeOn: aStream.
	aStream nextPutAll: ' at: '.
	self position storeOn: aStream.
	aStream nextPut: $)