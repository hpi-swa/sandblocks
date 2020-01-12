decorators
toggleDecorator: aDecorator

	^ decorators
		detect: [:d | d class = aDecorator class]
		ifFound: [self detachDecorator: aDecorator]
		ifNone: [self attachDecorator: aDecorator]