actions
swapRight

	| next children |
	children := self selection parentSandblock childSandblocks.
	next := children atWrap: (children indexOf: self selection) + 1.
	
	(next notNil and: [self selection isExpression and: [next isExpression]]) ifTrue: [
		self do: ((SBSwapCommand newFor: self method) a: self selection; b: next)]