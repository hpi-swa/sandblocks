*Sandblocks-ActiveExpression
asSandblock

	^ SBAssignment new
		binding: self variable asDeclarationSandblock
		value: self value asSandblock;
		pc: self pc;
		yourself