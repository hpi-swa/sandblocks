as yet unclassified
contentsChanged

	(self contents = 'true' or: [self contents = 'false'])
		ifTrue: [^ self behavior: SBBoolean new]
		ifFalse: [self behavior isBooleanBlock ifTrue: [^ self behavior: SBBinding new]].
	self isReserved
		ifTrue: [^ self behavior: SBKeywordBinding new]
		ifFalse: [self behavior isKeyword ifTrue: [^ self behavior: SBBinding new]].
	
	super contentsChanged