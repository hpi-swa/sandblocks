decorators
ensureDecorator: aClass do: aBlock

	decorators detect: [:d | d class = aClass] ifFound: aBlock ifNone: [| d |
		d := aClass new.
		self attachDecorator: d.
		aBlock value: d]