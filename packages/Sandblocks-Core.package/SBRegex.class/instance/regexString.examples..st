as yet unclassified
regexString: aString examples: aCollection

	self contents: aString.
	
	examples removeAllMorphs.
	aCollection do: [:example | self addExample: example]