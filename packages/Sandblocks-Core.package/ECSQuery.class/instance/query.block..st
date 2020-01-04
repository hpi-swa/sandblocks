as yet unclassified
query: anArray block: aBlock

	self addMorphBack: anArray.
	self addMorphBack: (bindings := SBRow new).
	self addMorphBack: aBlock.
	
	anArray childSandblocks do: [:symbol |
		bindings addMorphBack: (SBDeclarationForBlock new contents: symbol contents withFirstCharacterDownshifted)]