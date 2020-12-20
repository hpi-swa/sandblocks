hierarchy
lastDeepChild

	| current |
	current := self.
	[current childSandblocks isEmpty] whileFalse: [current := current childSandblocks last].
	^ current