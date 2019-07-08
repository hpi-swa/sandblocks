suggestions
completionSuggestionsFor: aString

	^ aString size > 2 ifTrue: [Symbol allSymbols select: [:sym | sym asString beginsWith: aString]] ifFalse: [#()]