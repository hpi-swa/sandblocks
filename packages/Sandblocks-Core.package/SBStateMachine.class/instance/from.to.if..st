transitions
from: startState to: endState if: aBlock
	" transition when aBlock becomes true "
	(conditionalTransitions at: startState ifAbsentPut: [ Dictionary new ])
		at: aBlock
		put: endState