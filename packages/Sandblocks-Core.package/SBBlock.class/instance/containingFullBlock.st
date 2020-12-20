as yet unclassified
containingFullBlock

	| next |
	next := self.
	[next := next parentSandblock ifNil: [^ nil]] doWhileFalse: [next isBlockBody and: [next startPC notNil]].
	^ next