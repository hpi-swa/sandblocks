actions
swapLeft

	| next children |
	children := self selection parentSandblock childSandblocks.
	next := children atWrap: (children indexOf: self selection) - 1.
	
	(next notNil and: [self selection canSwap and: [next canSwap]]) ifTrue: [
		self do: ((SBSwapCommand newFor: self method) a: self selection; b: next)]