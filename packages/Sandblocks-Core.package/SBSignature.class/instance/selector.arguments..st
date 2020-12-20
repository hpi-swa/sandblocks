as yet unclassified
selector: aString arguments: aCollection

	| messageParts |
	messageParts := self messageParts.
	(self extractKeywords: aString) withIndexDo: [:keyword :index |
		messageParts
			at: index
			ifPresent: [:p |
				p contents ~= keyword ifTrue: [p replaceBy: (self textMorphFor: keyword)]]
			ifAbsent: [
				self addMorph: (self textMorphFor: keyword) asElementNumber: (index * 2) - 1].
		((keyword endsWith: ':') or: [
			keyword notEmpty and: [keyword allSatisfy: #isSpecial]]) ifTrue: [
			self arguments
				at: index
				ifPresent: [:a | a replaceBy: (aCollection at: index)]
				ifAbsent: [
					self addMorph: (aCollection at: index) asElementNumber: index * 2]]].
	[
		self submorphs size > (aCollection size * 2 max: 1)] whileTrue: [self lastSubmorph delete]