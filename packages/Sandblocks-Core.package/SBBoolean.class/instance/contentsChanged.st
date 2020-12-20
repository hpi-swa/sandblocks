as yet unclassified
contentsChanged

	(self contents = 'true' or: [self contents = 'false'])
		ifFalse: [^ self block behavior: (self block isReserved ifTrue: [SBKeywordBinding] ifFalse: [SBBinding new])]