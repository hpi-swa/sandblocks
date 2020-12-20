as yet unclassified
nodeFrom: aString class: aClass noPattern: aBoolean

	| methodNode |
	methodNode := Parser new parse: aString class: aClass noPattern: aBoolean notifying: nil ifFail: nil.
	^ aBoolean ifTrue: [methodNode body statements first expr] ifFalse: [methodNode]