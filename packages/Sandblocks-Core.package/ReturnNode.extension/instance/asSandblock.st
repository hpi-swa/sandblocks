*Sandblocks-Core
asSandblock
	
	^ SBReturn new
		expression: self expr asSandblock;
		pc: self pc;
		yourself