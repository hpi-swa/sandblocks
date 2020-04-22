*Sandblocks-Core
asMethodBodySandblock
	
	| s |
	s := (self statements last class = ReturnNode and: [self statements last expr class = VariableNode and: [self statements last expr key = 'self']])
		ifTrue: [self statements allButLast]
		ifFalse: [self statements].
	
	^ SBBlockBody new
		statements: (s collect: #asSandblock);
		temporaries: (self temporaries collect: #asSandblock);
		bindings: (self arguments collect: #asSandblock);
		pc: self pc;
		yourself