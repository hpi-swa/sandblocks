Extension { #name : #BlockNode }

{ #category : #'*Sandblocks-Core' }
BlockNode >> asMethodBodySandblock [
	
	| s body |
	s := (self statements last class = ReturnNode and: [(self statements last expr isKindOf: VariableNode) and: [self statements last expr key = 'self']])
		ifTrue: [self statements allButLast]
		ifFalse: [self statements].
	body := SBStBlockBody new.
	
	^ body
		statements: (self statementsAsSandblocks: s in: body);
		temporaries: (self temporaries collect: #asSandblock);
		bindings: #();
		pc: self pc;
		yourself
]

{ #category : #'*Sandblocks-Core' }
BlockNode >> asSandblock [
	
	| body |
	body := SBStBlockBody new.
	^ body
		statements: (self isEmptyBlock ifTrue: [#()] ifFalse: [self statementsAsSandblocks: self statements in: body]);
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

{ #category : #'*Sandblocks-Core' }
BlockNode >> statementsAsSandblocks: aCollection in: aBlock [

	^ Array streamContents: [:stream |
		self comment ifNotNil: [self comment do: [:c | stream nextPut: (aBlock newCommentBlock contents: c)]].
		
		aCollection do: [:statement |
			stream nextPut: statement asSandblock.
			statement accept: (PPOriginalEnumerator
				ofBlock: [:node | node comment ifNotNil: [node comment do: [:c | stream nextPut: (aBlock newCommentBlock contents: c)]]]
				select: [:node | node isBlockNode not])]]
]
