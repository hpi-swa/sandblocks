as yet unclassified
containingStatement

	| current |
	current := self.
	[current owner ifNil: [^ nil] ifNotNil: [:o | o isKindOf: SBBlockBody]] whileFalse: [current := current owner].
	^ current