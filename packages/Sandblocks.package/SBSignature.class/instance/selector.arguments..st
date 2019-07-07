as yet unclassified
selector: aString arguments: aCollection

	self removeAllMorphs.
	(self extractKeywords: aString) withIndexDo: [:keyword :index |
		self addMorphBack: (self textMorphFor: keyword).
		((keyword endsWith: ':') or: [keyword notEmpty and: [keyword allSatisfy: #isSpecial]]) ifTrue: [
			self addMorphBack: (aCollection at: index)]]