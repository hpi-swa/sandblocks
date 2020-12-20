transitions
trigger: aSignal
	(signalTransitions at: self state) at: aSignal ifPresent: [ :endState |
		self state: endState ]