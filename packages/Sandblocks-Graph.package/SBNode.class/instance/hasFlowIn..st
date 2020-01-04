as yet unclassified
hasFlowIn: aBoolean

	aBoolean
		ifTrue: [self addMorphFront: flowIn]
		ifFalse: [flowIn delete].
	
	(aBoolean not and:  [isFlowSource not]) ifTrue: [self hasFlowOut: false]