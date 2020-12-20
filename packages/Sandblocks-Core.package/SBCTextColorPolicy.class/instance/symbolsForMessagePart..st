as yet unclassified
symbolsForMessagePart: aBlock

	| first |
	first := aBlock childIndex = 2 ifTrue: ['.'] ifFalse: [nil].
	^ aBlock isUnary ifTrue: [{first. '()'}] ifFalse: [{first. nil}]