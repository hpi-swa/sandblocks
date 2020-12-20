transitions
fromAll: startStates to: endState when: aSignal
	startStates do: [ :startState | self from: startState to: endState when: aSignal ]