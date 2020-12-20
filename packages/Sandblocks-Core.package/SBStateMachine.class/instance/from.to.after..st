transitions
from: startState to: endState after: aDuration
	" transition after spending `aDuration` in startState "
	(timeTransitions at: startState ifAbsentPut: [ Dictionary new ])
		at: endState
		put: {aDuration. aDuration}