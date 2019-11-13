converting
valid

	^ type ~= #literal or: [self childSandblocks allSatisfy: #isLiteralBlock]