Extension { #name : #BlockNode }

{ #category : #'*Sandblocks-Core' }
BlockNode >> asMethodBodySandblock [
	
	| s |
	s := (self statements last class = ReturnNode and: [self statements last expr class = VariableNode and: [self statements last expr key = 'self']])
		ifTrue: [self statements allButLast]
		ifFalse: [self statements].
	
	^ SBStBlockBody new
		statements: (s collect: #asSandblock);
		temporaries: (self temporaries collect: #asSandblock);
		bindings: #();
		pc: self pc;
		yourself
]

{ #category : #'*Sandblocks-Core' }
BlockNode >> asSandblock [
	
	^ SBStBlockBody new
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
]

{ #category : #'*Sandblocks-Core' }
BlockNode >> closureCreationNode [

	^ closureCreationNode
]

{ #category : #'*Sandblocks-Core' }
BlockNode >> closureCreationNode: aNode [

	closureCreationNode := aNode
]

{ #category : #'*Sandblocks-Core' }
BlockNode >> isEmptyBlock [

	^ self statements size = 1 and: [self statements first isVariableNode and: [self statements first key = 'nil' and: [self startOfLastStatement isNil]]]
]
