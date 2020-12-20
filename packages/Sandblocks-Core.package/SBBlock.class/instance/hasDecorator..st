decorators
hasDecorator: aClass

	^ decorators anySatisfy: [:d | d class = aClass]