*Sandblocks-Core
asSandblock
	
	^ SBBlockBody new
		statements: (self statements collect: #asSandblock);
		temporaries: (self temporaries collect: #asDeclarationSandblock);
		bindings: (self arguments collect: #asBlockBindingSandblock);
		pc: "self pc"closureCreationNode pc;
		yourself