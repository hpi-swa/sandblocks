as yet unclassified
browseImplementors

	| list |
	self selector ifNotNil: [:sel |
		"self systemNavigation browseAllImplementorsOf: sel asSymbol".
		list := self systemNavigation allImplementorsOf: sel asSymbol.
		list size = 1
			ifTrue: [self sandblockEditor open: list first compiledMethod]
			ifFalse: [self systemNavigation browseAllImplementorsOf: sel asSymbol]]