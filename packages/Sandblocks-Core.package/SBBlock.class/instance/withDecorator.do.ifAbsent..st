decorators
withDecorator: aClass do: aBlock ifAbsent: anotherBlock

	^ decorators detect: [:d | d class = aClass] ifFound: aBlock ifNone: anotherBlock