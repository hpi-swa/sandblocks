*Sandblocks-Core
visibleInWorld

	^ (self firstOwnerSuchThat: [:o | o visible not])
		ifNotNil: [false] ifNil: [true]