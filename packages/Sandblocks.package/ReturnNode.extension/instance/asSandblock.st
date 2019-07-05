*Sandblocks
asSandblock
	
	^ SBReturn new
		expression: self expr asSandblock;
		pc: self pc;
		yourself