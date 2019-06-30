*Sandblocks
asSandblock
	
	^ SBBlockBody new
		statements: (self statements collect: #asSandblock);
		temporaries: (self temporaries collect: #asSandblock);
		bindings: (self arguments collect: #asBlockBindingSandblock)