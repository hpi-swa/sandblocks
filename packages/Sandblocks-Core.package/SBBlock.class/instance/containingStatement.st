as yet unclassified
containingStatement

	| current |
	current := self.
	[current parentSandblock ifNil: [^ nil] ifNotNil: #isBlockBody] whileFalse: [current := current parentSandblock].
	^ current