as yet unclassified
simulateContext: aContext untilReached: anotherContext

	currentContext := aContext."
	currentContext pushArgs: Array new from: simulationContext."
	[currentContext == anotherContext] whileFalse: [
		currentContext := currentContext interpretNextInstructionFor: self].
	^ currentContext pop