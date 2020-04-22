*Sandblocks-Core
asSandblock
	
	^ SBBlockBody new
		statements: (self statements collect: #asSandblock);
		temporaries: (self temporaries select: [:node | node scope ~= -2] thenCollect: #asSandblock);
		bindings: (self arguments collect: #asSandblock);
		pc: closureCreationNode pc;
		yourself