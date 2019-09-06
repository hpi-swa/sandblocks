as yet unclassified
hasFlowOut: aBoolean

	aBoolean
		ifTrue: [self addMorphBack: flowOut]
		ifFalse: [flowOut delete]