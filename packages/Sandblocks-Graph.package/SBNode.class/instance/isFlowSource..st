as yet unclassified
isFlowSource: aBoolean

	self hasFlowOut: aBoolean.
	isFlowSource := aBoolean.
	aBoolean ifTrue: [self hasFlowIn: false]