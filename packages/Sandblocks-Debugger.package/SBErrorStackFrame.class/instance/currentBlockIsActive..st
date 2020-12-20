as yet unclassified
currentBlockIsActive: aBoolean

	| pc |
	pc := aBoolean ifTrue: [context pc] ifFalse: [context previousPc].
	^ self method blockForPC: (context closure ifNotNil: [:c | c method -> pc] ifNil: [pc])