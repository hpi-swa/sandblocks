as yet unclassified
lowercaseSuggestions

	| method |
	method := self containingArtefact.
	
	^ Array streamContents: [:str |
		self containingBlocksDo: [:block |
			(block temporaries select: [:v | v contents sandblockMatch: self contents] thenDo: [:v | str nextPut: (SBSuggestionItem selector: v contents label: 'temporary')]).
			(block bindings select: [:v | v contents sandblockMatch: self contents] thenCollect: [:v | str nextPut: (SBSuggestionItem selector: v contents label: 'block var')])].
		
		(method arguments select: [:v | v contents sandblockMatch: self contents] thenDo: [:v | str nextPut: (SBSuggestionItem selector: v contents label: 'argument')]),
		(method instanceVariables select: [:v | v contents sandblockMatch: self contents] thenDo: [:v | str nextPut: (SBSuggestionItem selector: v contents label: 'instance')])]