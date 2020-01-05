as yet unclassified
value: aNumber

	value := aNumber.
	step := aNumber isInteger ifTrue: [1] ifFalse: [0.1].
	self contents: (aNumber isInteger ifTrue: [aNumber] ifFalse: [aNumber printShowingDecimalPlaces: 2]) asString