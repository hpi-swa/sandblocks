converting
isExpression

	^ self parentSandblock ifNil: [true] ifNotNil: [:p | p isMethod not]