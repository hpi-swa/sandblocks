as yet unclassified
lowercaseSuggestions

	^ Array streamContents: [:str |
		self containingArtefact declarations select: [:v | v contents sandblockMatch: self contents] thenDo: [:v | str nextPut: v asSuggestionItem].
		self containingBlocksDo: [:block |
			(block temporaries select: [:v | v contents sandblockMatch: self contents] thenDo: [:v | str nextPut: v asSuggestionItem]).
			(block bindings select: [:v | v contents sandblockMatch: self contents] thenCollect: [:v | str nextPut: v asSuggestionItem])]]