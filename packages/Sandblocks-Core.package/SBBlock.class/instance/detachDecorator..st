decorators
detachDecorator: aDecorator

	decorators remove: aDecorator ifAbsent: [].
	self world ifNotNil: [:w | w stopStepping: aDecorator selector: #step].
	aDecorator detached: self.
	self changed