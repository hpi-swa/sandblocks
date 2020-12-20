transitions
tick: dt
	" iterate over all active conditional and time transitions and check if they were triggered "
	| passedDuration |
	passedDuration := dt seconds.
	
	(conditionalTransitions at: self state) keysAndValuesDo: [ :conditionalBlock :endState |
		conditionalBlock value ifTrue: [ ^self state: endState ]].
	
	(timeTransitions at: self state) keysAndValuesDo: [ :endState :time |
		time at: 1 put: time first - passedDuration.
		time first negative ifTrue: [ ^self state: endState ]]