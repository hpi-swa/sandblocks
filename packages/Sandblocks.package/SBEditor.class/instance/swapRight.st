actions
swapRight

	| next |
	next := self selection morphAfterThat: #isSandblock.
	next ifNotNil: [self do: (SBSwapCommand new a: self selection; b: next)]