hierarchy
firstDeepChild

	| current |
	current := self.
	[current childSandblocks isEmpty] whileFalse: [current := current childSandblocks first].
	^ current