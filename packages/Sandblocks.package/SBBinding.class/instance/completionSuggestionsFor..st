as yet unclassified
completionSuggestionsFor: aString

	^ self resolveBinding
		ifNotNil: [:b | b completionSuggestionsFor: aString]
		ifNil: [super completionSuggestionsFor: aString]