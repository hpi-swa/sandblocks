as yet unclassified
blockStatementsOf: aNode

	aNode statements ifEmpty: [^ #()].
	SBLabel text: ['note: this will also strip away legitimate return selfs'].
	^ (((self parentFor: aNode) isKindOf: MethodNode) and: [(aNode statements last isKindOf: ReturnNode) and: [aNode statements last isReturnSelf]]) ifTrue: [aNode statements allButLast] ifFalse: [aNode statements]