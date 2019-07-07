selection
internalSelect: aBlock

	| previousSelection |
	previousSelection := selection.
	aBlock
		ifNil: [
			selection := nil.
			previousSelection ifNotNil: #changed]
		ifNotNil: [
			selection := aBlock.
			previousSelection ifNotNil: #changed.
			selection changed].
	self changed.
	self updateSelectionLabel