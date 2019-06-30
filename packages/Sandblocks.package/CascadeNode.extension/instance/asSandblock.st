*Sandblocks
asSandblock

	^ SBCascade new
		receiver: self receiver asSandblock
		messages: (self messages collect: #asSandblock)