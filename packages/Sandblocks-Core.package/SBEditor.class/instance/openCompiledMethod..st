actions
openCompiledMethod: aMethod

	^ self methods
		detect: [:m | m selector = aMethod selector and: [m methodClass = aMethod methodClass]]
		ifFound: [:m | m select]
		ifNone: [self openMorphInView: aMethod asSandblock]