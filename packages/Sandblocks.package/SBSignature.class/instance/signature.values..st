as yet unclassified
signature: aString values: aCollection

	self removeAllMorphs.
	(aString keywords ifEmpty: [#('')]) withIndexDo: [:keyword :index |
		self addMorphBack: (SBOwnTextMorph new contents: keyword; emphasis: TextEmphasis bold).
		((keyword endsWith: ':') or: [keyword notEmpty & (keyword allSatisfy: #isSpecial)]) ifTrue: [
			self addMorphBack: (aCollection at: index)]]