*Sandblocks-Core
asSandblock

	^ SBAssignment new
		binding: self variable asSandblock
		value: self value asSandblock;
		pc: self pc;
		yourself