as yet unclassified
contentsChanged

	(self contents = 'true' or: [self contents = 'false'])
		ifTrue: [^ self block behavior: SBBoolean new].
	
	self block isReserved
		ifFalse: [^ self block behavior: SBBinding new]