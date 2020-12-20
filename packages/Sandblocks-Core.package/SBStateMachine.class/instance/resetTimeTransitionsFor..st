private
resetTimeTransitionsFor: aState
	(timeTransitions at: aState) keysAndValuesDo: [ :endState :time |
		time at: 1 put: time second ]