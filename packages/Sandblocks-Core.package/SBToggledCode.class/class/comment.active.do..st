as yet unclassified
comment: aString active: aNumber do: aCollection

	^ aNumber > 0 ifTrue: [(aCollection at: aNumber) value] ifFalse: [nil]