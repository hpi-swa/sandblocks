*Sandblocks-Core
asSandblock

	^ SBCascade new
		receiver: self receiver asSandblock
		messages: (self messages collect: #asCascadePartSandblock)