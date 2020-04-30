as yet unclassified
query: anArray block: aBlock

	self addMorphBack: anArray.
	self addMorphBack: (bindings := SBRow new).
	self addMorphBack: aBlock.
	
	anArray childSandblocksDo: [:symbol |
		bindings addMorphBack: (SBName contents: symbol contents withFirstCharacterDownshifted)]