transitions
fromAll: startStates to: endState after: aDuration
	startStates do: [ :startState | self from: startState to: endState after: aDuration ]