decorators
attachDecorator: aDecorator

	decorators add: aDecorator.
	aDecorator attached: self.
	self changed.
	self updateSteppingDecorators