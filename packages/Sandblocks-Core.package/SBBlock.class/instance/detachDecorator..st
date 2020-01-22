decorators
detachDecorator: aDecorator

	decorators remove: aDecorator.
	aDecorator detached: self.
	self changed