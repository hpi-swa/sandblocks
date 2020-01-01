as yet unclassified
typeFor: aBlock

	^ typeCache ifNil: [nil] ifNotNil: [aBlock pc = 0 ifTrue: [nil] ifFalse: [typeCache at: aBlock pc ifAbsent: [nil]]]