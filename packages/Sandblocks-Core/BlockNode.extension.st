Extension { #name : #BlockNode }

{ #category : #'*Sandblocks-Core' }
BlockNode >> asMethodBodySandblock [
	
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
]

{ #category : #'*Sandblocks-Core' }
BlockNode >> asSandblock [
	
	^ SBBlockBody new
		statements: (Array streamContents: [:stream |
			self isEmptyBlock ifFalse: [
				self statements do: [:statement |
					statement comment ifNotNil: [:comment | stream nextPut: (SBLabel new contents: comment first)].
				stream nextPut: statement asSandblock]]]);
		temporaries: (self temporaries select: [:node | node scope ~= -2] thenCollect: #asSandblock);
		bindings: (self arguments collect: #asSandblock);
		pc: closureCreationNode pc;
		yourself
]

{ #category : #'*Sandblocks-Core' }
BlockNode >> isEmptyBlock [

	^ self statements size = 1 and: [self statements first isVariableNode and: [self statements first key = 'nil' and: [self startOfLastStatement isNil]]]
]
