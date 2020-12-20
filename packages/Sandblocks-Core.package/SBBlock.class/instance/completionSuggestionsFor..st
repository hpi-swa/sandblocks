suggestions
completionSuggestionsFor: aString

	^ aString size > 2
		ifTrue: [ | baseClass |
			baseClass := self guessClassExpensive.
			baseClass isNil
				ifFalse: [
					Array streamContents: [:stream |
						baseClass withAllSuperclassesDo: [:class |
							class methodsDo: [:m | | sel |
								sel := m selector asString.
								(sel sandblockMatch: aString) ifTrue: [stream nextPut: sel]]]]]
				ifTrue: [Symbol allSymbols select: [:sym | sym asString sandblockMatch: aString]]]
		ifFalse: [#()]