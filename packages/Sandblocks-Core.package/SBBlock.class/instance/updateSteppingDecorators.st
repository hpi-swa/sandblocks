testing
updateSteppingDecorators

	| anyStepping |
	anyStepping := false.
	self decorators do: [:d |
		d stepTime >= 0 ifTrue: [
			anyStepping := true.
			self world ifNotNil: [:w | w startStepping: d at: Time millisecondClockValue selector: #step arguments: {} stepTime: d stepTime]]]