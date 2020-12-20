as yet unclassified
layoutInsetFor: aBlock

	((aBlock isKindOf: SBLiteral) or: [aBlock isBlockBody]) ifTrue: [^ 2 @ 1].
	^ (aBlock isMessageSend or: [aBlock isAssignment or: [aBlock isReturn]]) ifTrue: [2 @ 0] ifFalse: [2 @ 2]