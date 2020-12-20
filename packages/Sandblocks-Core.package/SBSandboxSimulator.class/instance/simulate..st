as yet unclassified
simulate: aBlock

	| simulationContext startTime |
	SBExample self: [SBSandboxSimulator new] args: [{[#(12 2 2.0)]}] label: 'array'.
	SBExample self: [SBSandboxSimulator new] args: [{[TextMorph new]}] label: 'text morph'.
	SBExample self: [SBSandboxSimulator new] args: [{[Time current]}] label: 'time'.
	SBExample self: [SBSandboxSimulator new] args: [{[10000 factorial]}] label: 'slow'.
	SBExample self: [SBSandboxSimulator new] args: [{[4 + 5]}] label: 'numbers'.
	SBExample self: [SBSandboxSimulator new] args: [{[ActiveWorld addMorph: Morph new]}] label: 'morph'.
	SBExample self: [SBSandboxSimulator new] args: [{[UIManager default]}] label: 'ui manager'.
	startTime := DateAndTime now.
	aBlock hasMethodReturn ifTrue: [
		self error: 'simulation of blocks with ^ can run loose'].
	simulationContext := thisContext.
	currentContext := aBlock asContext.
	currentContext pushArgs: Array new from: simulationContext.
	[
		currentContext notNil and: [currentContext ~~ simulationContext]] whileTrue: [
		currentContext := currentContext interpretNextInstructionFor: self.
		(DateAndTime now - startTime) > self maxTime ifTrue: [^ SBExampleWatch report: nil for: 570645926]].
	^ currentContext ifNil: [nil] ifNotNil: [simulationContext pop]