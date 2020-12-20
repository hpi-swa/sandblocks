transitions
fromAll: startStates to: endState if: aBlock
	startStates do: [ :startState | self from: startState to: endState if: aBlock ]