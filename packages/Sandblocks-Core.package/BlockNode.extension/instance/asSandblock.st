*Sandblocks-Core
asSandblock
	
	^ SBBlockBody new
		statements: (Array streamContents: [:stream |
			self isEmptyBlock ifFalse: [
				self statements do: [:statement |
					statement comment ifNotNil: [:comment | stream nextPut: (SBLabel new contents: comment first)].
				stream nextPut: statement asSandblock]]]);
		temporaries: (self temporaries select: [:node | node scope ~= -2] thenCollect: #asSandblock);
		bindings: (self arguments collect: #asSandblock);
		pc: (closureCreationNode ifNotNil: [:n | n pc] ifNil: [0]);
		startPC: (closureCreationNode ifNotNil: [:n | n key isCompiledCode ifTrue: [n key -> n key initialPC] ifFalse: [0]] ifNil: [0]);
		endPC: (pc ifNil: [0]);
		yourself