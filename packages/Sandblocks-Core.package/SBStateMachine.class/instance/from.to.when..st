transitions
from: startState to: endState when: aSignal
	" transition upon receiving a signal "
	(signalTransitions at: startState ifAbsentPut: [ Dictionary new ])
		at: aSignal
		put: endState