as yet unclassified
containingBlock

	| next |
	next := self.
	[next := next parentSandblock ifNil: [^ nil]] doWhileFalse: [next isBlockBody].
	^ next