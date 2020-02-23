*Sandblocks-Core
asSandblockWithoutSubstitution

	^ SBCascade new
		receiver: self receiver asSandblock
		messages: (self messages collect: #asCascadePartSandblock)