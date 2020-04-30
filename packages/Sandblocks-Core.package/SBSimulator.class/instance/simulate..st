as yet unclassified
simulate: aBlock
	
	| simulationContext |
	aBlock hasMethodReturn ifTrue: [self error: 'simulation of blocks with ^ can run loose'].
	simulationContext := thisContext.
	currentContext := aBlock asContext.
	currentContext pushArgs: Array new from: simulationContext.
	[currentContext notNil and: [currentContext ~~ simulationContext]] whileTrue: [
		currentContext := currentContext interpretNextInstructionFor: self].
	^ currentContext ifNil: [nil] ifNotNil: [simulationContext pop]