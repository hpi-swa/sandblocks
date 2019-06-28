as yet unclassified
signature: aString values: aCollection

	self removeAllMorphs.
	aString keywords withIndexDo: [:keyword :index |
		self addMorphBack: (SBTextMorph new contents: keyword).
		((keyword endsWith: ':') or: [keyword allSatisfy: #isSpecial]) ifTrue: [
			self addMorphBack: (aCollection at: index)]]