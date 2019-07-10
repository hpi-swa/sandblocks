as yet unclassified
containingStatement

	| current |
	current := self.
	[current owner ifNil: [^ nil] ifNotNil: #isBlockBody] whileFalse: [current := current owner].
	^ current