as yet unclassified
signature: aString values: aCollection

	self removeAllMorphs.
	(self extractKeywords: aString) withIndexDo: [:keyword :index |
		self addMorphBack: (self textMorphFor: keyword).
		((keyword endsWith: ':') or: [keyword notEmpty & (keyword allSatisfy: #isSpecial)]) ifTrue: [
			self addMorphBack: (aCollection at: index)]]