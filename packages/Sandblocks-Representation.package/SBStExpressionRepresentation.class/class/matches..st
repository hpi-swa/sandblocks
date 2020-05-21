as yet unclassified
matches: anObject

	self flag: #todo. " incorrect to assume that these are sandblocks, but currently practical "
	^ anObject isSandblock and: [anObject isExpression]