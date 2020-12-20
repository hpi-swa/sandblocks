*Sandblocks-Core
parseAsSandblock

	SBExample self: ['5 + 12 squared'] args: [{}] label: 'simple'.
	^ self parseAsNode asSandblock