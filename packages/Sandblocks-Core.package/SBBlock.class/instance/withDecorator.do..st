decorators
withDecorator: aClass do: aBlock

	decorators detect: [:d | d class = aClass] ifFound: aBlock ifNone: []