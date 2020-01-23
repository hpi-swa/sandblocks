as yet unclassified
simulate: aBlock

	| simulationContext |
	aBlock hasMethodReturn
		ifTrue: [self error: 'simulation of blocks with ^ can run loose']. "could probably be solved by guarding method returns"
	
	simulationContext := thisContext.
	currentContext := topContext := aBlock asContext.
	currentContext pushArgs: Array new from: simulationContext.
	[currentContext == simulationContext] whileFalse: [
		currentContext := currentContext interpretNextInstructionFor: self].
	^ simulationContext pop