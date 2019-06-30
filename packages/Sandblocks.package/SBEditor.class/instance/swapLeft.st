actions
swapLeft

	| next |
	next := self selection morphBeforeThat: #isSandblock.
	next ifNotNil: [self do: (SBSwapCommand new a: self selection; b: next)]