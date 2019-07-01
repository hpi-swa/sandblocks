selection
internalSelect: aBlock

	| previousSelection |
	previousSelection := selection.
	aBlock
		ifNil: [
			selection := nil.
			selectionLabel contents: ''.
			previousSelection ifNotNil: #changed]
		ifNotNil: [
			selection := aBlock.
			previousSelection ifNotNil: #changed.
			selection changed.
			selectionLabel contents: selection printString].
		self changed