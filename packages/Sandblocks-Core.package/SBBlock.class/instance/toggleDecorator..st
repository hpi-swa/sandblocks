decorators
toggleDecorator: aDecorator

	^ decorators
		detect: [:d | d class = aDecorator class]
		ifFound: [:d | self detachDecorator: d]
		ifNone: [self attachDecorator: aDecorator]