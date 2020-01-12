as yet unclassified
constructorString: aString arguments: aCollection on: aStream

	SBExample
		self: [SBSubstitution new]
		args: [{'replace:'. ({(SBNumber new contents: '3')}). '' writeStream}]
		label: 'simple'.
	aStream nextPut: $(.
	aStream nextPutAll: self className.
	aStream space.
	aString keywords
		with: aCollection
		do: [:keyword :arg | 
			aStream nextPutAll: keyword.
			aStream space.
			arg writeSourceOn: aStream.
			aStream space].
	aStream nextPut: $)