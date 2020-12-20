as yet unclassified
eagerNewFor: anObject
	" called when eagerly evaluating representations for finding nested combinations.
	Override if eagerly evaluating will be costly or cause side effects "

	^ self causesSideEffects ifTrue: [nil] ifFalse: [self newFor: anObject]