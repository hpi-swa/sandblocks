suggestions
completionSuggestionsFor: aString

	^ aString size > 2
		ifTrue: [
			self guessClassExpensive
				ifNotNil: [:baseClass | 
					Array streamContents: [:stream | 
						baseClass withAllSuperclassesDo: [:class | 
							class methodsDo: [:m |  | sel |
								sel := m selector asString.
								(sel sandblockMatch: aString) ifTrue: [stream nextPut: sel]]]]]
				ifNil: [Symbol allSymbols select: [:sym | sym asString sandblockMatch: aString]]]
		ifFalse: [#()]