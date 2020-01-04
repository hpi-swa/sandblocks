as yet unclassified
maybeRemoveFlowIn

	isFlowSource ifTrue: [^ self].
	
	self hasFlowIn: false