as yet unclassified
hasFlowOut

	^ self flowInSocket connectedLinks notEmpty or: [self inCascade]