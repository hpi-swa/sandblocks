as yet unclassified
borderColorForBlock: aBlock

	(aBlock isBlockBody and: [aBlock parentSandblock isMethod]) ifTrue: [^ Color white].
	
	^ aBlock isBlockBody ifTrue: [Color black] ifFalse: [Color black alpha: 0.2]