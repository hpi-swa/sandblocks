as yet unclassified
connect: aStateName to: anotherStateName if: aBlock

	| line states connectors |
	connectors := self connectors.
	states := self states.
	line := connectors
		detect: [:transition |
			transition from name = aStateName and: [transition to name = anotherStateName]]
		ifFound: #yourself
		ifNone: [
			SBStateMachineTransition connect: (states at: aStateName) to: (states at: anotherStateName)].
	connectors
		detect: [:transition |
			transition to name = aStateName and: [transition from name = anotherStateName]]
		ifFound: [:transition |
			transition evade: #right.
			line evade: #right].
	line addCondition: aBlock.
	self addMorphBack: line.
	^ line