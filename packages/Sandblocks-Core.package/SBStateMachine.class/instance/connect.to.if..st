as yet unclassified
connect: aStateName to: anotherStateName if: aBlock

	| line |
	line := connectors
		detect: [:transition | transition from name = aStateName and: [transition to name = anotherStateName]]
		ifFound: #yourself
		ifNone: [SBStateMachineTransition connect: (states at: aStateName) to: (states at: anotherStateName)].
	line addCondition: aBlock.
	self addMorphBack: line.
	^ connectors add: line