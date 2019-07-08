as yet unclassified
completionSuggestionsFor: aString

	^ self classForBinding
		ifNotNil: [:baseClass |
			aString size < 2
				ifTrue: [#()]
				ifFalse: [
					Array streamContents: [:stream |
						baseClass withAllSuperclassesDo: [:class |
							class methodsDo: [:m | | sel |
								sel := m selector asString.
								(sel sandblockMatch: aString) ifTrue: [stream nextPut: sel]]]]]]
		ifNil: [super completionSuggestionsFor: aString]