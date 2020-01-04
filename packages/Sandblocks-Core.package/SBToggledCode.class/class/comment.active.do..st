as yet unclassified
comment: aString active: aBoolean do: aBlock

	^ aBoolean ifTrue: aBlock ifFalse: [nil]