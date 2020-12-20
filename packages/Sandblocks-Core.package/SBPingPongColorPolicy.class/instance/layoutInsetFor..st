as yet unclassified
layoutInsetFor: aBlock

	((aBlock isKindOf: SBLiteral) or: [aBlock isBlockBody]) ifTrue: [^ 2 @ 2].
	
	aBlock isMessageSend ifTrue: [
		aBlock childHierarchyComplexity > 9 ifTrue: [^ 3 @ 3]].
	
	^ (aBlock isMessageSend or: [aBlock isAssignment or: [aBlock isReturn]]) ifTrue: [2 @ 0] ifFalse: [2 @ 2]