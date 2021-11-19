Class {
	#name : #SBStMethodToBlocks,
	#superclass : #ParseNodeVisitor,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStMethodToBlocks >> applyMessageSubstitutions: aBlock [

	^ aBlock
]

{ #category : #'as yet unclassified' }
SBStMethodToBlocks >> blockStatements: aCollection of: aBlockNode into: aBlock [

	^ Array streamContents: [:stream |
		aBlockNode comment ifNotNil: [aBlockNode comment do: [:c | stream nextPut: (aBlock newCommentBlock contents: c)]].
		
		aCollection do: [:statement |
			stream nextPut: (statement accept: self).
			statement accept: (PPOriginalEnumerator
				ofBlock: [:node | node comment ifNotNil: [node comment do: [:c | stream nextPut: (aBlock newCommentBlock contents: c)]]]
				select: [:node | node isBlockNode not])]]
]

{ #category : #'as yet unclassified' }
SBStMethodToBlocks >> visitAssignmentNode: anAssignmentNode [

	^ SBStMessageSend new
		binding: (anAssignmentNode variable accept: self)
			value: (anAssignmentNode value accept: self);
		pc: anAssignmentNode pc;
		yourself
]

{ #category : #'as yet unclassified' }
SBStMethodToBlocks >> visitBlockNode: aBlockNode [

	| body |
	body := SBStBlockBody new.
	^ body
		statements: (aBlockNode isEmptyBlock
			ifTrue: [#()]
			ifFalse: [self blockStatements: aBlockNode statements of: aBlockNode into: body]);
		temporaries: (aBlockNode temporaries
			select: [:node | node scope ~= -2]
			thenCollect: [:b | b accept: self]);
		bindings: (aBlockNode arguments collect: [:b | b accept: self]);
		pc: (aBlockNode closureCreationNode ifNotNil: [:n | n pc] ifNil: [0]);
		startPC: (aBlockNode closureCreationNode
			ifNotNil: [:n | n key isCompiledCode ifTrue: [n key -> n key initialPC] ifFalse: [0]]
			ifNil: [0]);
		endPC: (aBlockNode pc ifNil: [0]);
		yourself
]

{ #category : #'as yet unclassified' }
SBStMethodToBlocks >> visitBraceNode: aNode [

	^ SBStArray new type: #dynamic contents: (aNode elements collect: [:e | e accept: self])
]

{ #category : #'as yet unclassified' }
SBStMethodToBlocks >> visitCascadeNode: aNode [

	^ SBStCascade new receiver: (aNode receiver accept: self) messages: (aNode messages collect: [:b |
		(self visitMessageNodeInCascade: b)
			receiver: nil;
			yourself])
]

{ #category : #'as yet unclassified' }
SBStMethodToBlocks >> visitCommentNode: aCommentNode [

	self assert: false
]

{ #category : #'as yet unclassified' }
SBStMethodToBlocks >> visitFieldNode: aFieldNode [

	^ self visitVariableNode: aFieldNode
]

{ #category : #'as yet unclassified' }
SBStMethodToBlocks >> visitFutureNode: aNode [

	self assert: false
]

{ #category : #'as yet unclassified' }
SBStMethodToBlocks >> visitInstanceVariableNode: aNode [

	^ self visitVariableNode: aNode
]

{ #category : #nil }
SBStMethodToBlocks >> visitLiteralNode: aNode [

	^ LiteralNode sandblockForLiteral: aNode key
]

{ #category : #'as yet unclassified' }
SBStMethodToBlocks >> visitLiteralVariableNode: aNode [

	^ self visitVariableNode: aNode
]

{ #category : #'as yet unclassified' }
SBStMethodToBlocks >> visitMessageNode: aNode [

	| blockReceiver |
	blockReceiver := aNode originalReceiver accept: self.
	
	" the originalReceiver may not have gotten a pc set, so we copy it from the generated receiver "
	(blockReceiver pc = 0 and: [aNode receiver notNil]) ifTrue: [blockReceiver pc: aNode receiver pc].
	
	^ SBStGrammarHandler messageSendClass new
		receiver: blockReceiver
			selector: aNode originalSelector
			arguments: (aNode originalArguments collect: [:b | b accept: self]);
		pc: aNode pc
]

{ #category : #'as yet unclassified' }
SBStMethodToBlocks >> visitMessageNodeInCascade: aMessageNode [

	^ self visitMessageNode: aMessageNode
]

{ #category : #'as yet unclassified' }
SBStMethodToBlocks >> visitMethodBody: aNode [

	| s body |
	s := (aNode statements last class = ReturnNode and: [(aNode statements last expr isKindOf: VariableNode) and: [aNode statements last expr key = 'self']])
		ifTrue: [aNode statements allButLast]
		ifFalse: [aNode statements].
	
	body := SBStBlockBody new.
	
	^ body
		statements: (self blockStatements: s of: aNode into: body);
		temporaries: (aNode temporaries collect: [:b | b accept: self]);
		bindings: #();
		yourself
]

{ #category : #'as yet unclassified' }
SBStMethodToBlocks >> visitMethodNode: aNode [

	| method |
	method := SBStMethod new
		selector: aNode selector
			arguments: (aNode arguments collect: [:b | b accept: self])
			class: aNode methodClass;
		body: ((self visitMethodBody: aNode block) temporaries: (aNode temporaries collect: [:b | b accept: self]));
		methodComment: aNode comment;
		yourself.
	
	aNode properties pragmas reverseDo: [:pragma | method body prependStatement: (self visitPragma: pragma)].
	
	^ method
]

{ #category : #'as yet unclassified' }
SBStMethodToBlocks >> visitNewArrayNode: aNewArrayNode [

	self assert: false
]

{ #category : #'as yet unclassified' }
SBStMethodToBlocks >> visitPragma: aPragma [

	^ aPragma asSandblock
]

{ #category : #'as yet unclassified' }
SBStMethodToBlocks >> visitRemoteTempVectorNode: aRemoteTempVectorNode [

	^ self visitBraceNode: aRemoteTempVectorNode
]

{ #category : #'as yet unclassified' }
SBStMethodToBlocks >> visitReturnNode: aNode [

	^ SBStReturn new
		expression: (aNode expr accept: self);
		pc: aNode pc;
		yourself
]

{ #category : #'as yet unclassified' }
SBStMethodToBlocks >> visitSelectorNode: aSelectorNode [

	self assert: false
]

{ #category : #'as yet unclassified' }
SBStMethodToBlocks >> visitTempVariableNode: aVariableNode [

	^ self visitVariableNode: aVariableNode
]

{ #category : #'as yet unclassified' }
SBStMethodToBlocks >> visitUndeclaredVariableNode: aVariableNode [

	^ self visitVariableNode: aVariableNode
]

{ #category : #'as yet unclassified' }
SBStMethodToBlocks >> visitVariableNode: aNode [

	^ SBStName contents: aNode name
]
