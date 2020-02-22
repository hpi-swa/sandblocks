testing
updateSteppingDecorators

	| anyStepping |
	anyStepping := false.
	self decorators do: [:d |
		d stepTime >= 0 ifTrue: [
			anyStepping := true.
			self startStepping: #stepDecorator: at: Time millisecondClockValue arguments: {d} stepTime: d stepTime]].
	
	anyStepping ifFalse: [self stopSteppingSelector: #stepDecorator:]