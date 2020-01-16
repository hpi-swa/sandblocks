*Sandblocks-Core
asSandblock
	
	^ SBBlockBody new
		statements: (self statements collect: #asSandblock);
		temporaries: (self temporaries select: [:node | node scope ~= -2] thenCollect: #asDeclarationSandblock);
		bindings: (self arguments collect: #asBlockBindingSandblock);
		pc: "self pc"closureCreationNode pc;
		yourself