as yet unclassified
outputs

	^ self selector isUnary
		ifTrue: [{self selector asString}]
		ifFalse: [#('')]