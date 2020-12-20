actions
browseImplementors
	<action>

	| list |
	self selector ifNotNil: [:sel |
		list := self systemNavigation allImplementorsOf: sel asSymbol.
		list size = 1
			ifTrue: [self sandblockEditor open: list first compiledMethod]
			ifFalse: [self sandblockEditor openMorphInView: (SBCodeAccordion newFor: (list collect: #compiledMethod))]]