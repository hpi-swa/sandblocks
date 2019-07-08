suggestions
completionSuggestionsFor: aString

	^ aString size > 2 ifTrue: [Symbol allSymbols select: [:sym | sym asString sandblockMatch:  aString]] ifFalse: [#()]