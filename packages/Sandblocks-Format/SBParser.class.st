Class {
	#name : #SBParser,
	#superclass : #Parser,
	#category : #'Sandblocks-Format'
}

{ #category : #'as yet unclassified' }
SBParser >> addComment [

	parseNode ~~ nil
		ifTrue: 
			[currentComment ifNotNil: [parseNode comment: (parseNode comment ifNotNil: [parseNode comment, currentComment] ifNil: [currentComment])].
			currentComment := nil]
]

{ #category : #'as yet unclassified' }
SBParser >> method: doit context: ctxt [ 
	" pattern [ | temporaries ] block => MethodNode."

	| sap blk prim temps messageComment methodNode |
	sap := self pattern: doit inContext: ctxt.
	"sap={selector, arguments, precedence}"
	self properties selector: (sap at: 1).
	encoder selector: (sap at: 1).
	(sap at: 2) do: [:argNode | argNode beMethodArg].
	doit ifFalse: [self pragmaSequence].
	temps := self temporaries.
	messageComment := currentComment.
	currentComment := nil.
	doit ifFalse: [self pragmaSequence].
	prim := self pragmaPrimitives.
	self statements: #() innerBlock: false blockNode: BlockNode new.
	blk := parseNode.
	
	"THIS WE REMOVED: doit ifTrue: [blk returnLast]
		ifFalse: [blk returnSelfIfNoOther: encoder]."
	
	hereType == #doIt ifFalse: [^self expected: 'Nothing more'].
	methodNode := self newMethodNode comment: messageComment.
	methodNode
		selector: (sap at: 1)
		arguments: (sap at: 2)
		precedence: (sap at: 3)
		temporaries: temps
		block: blk
		encoder: encoder
		primitive: prim
		properties: properties.
	self interactive ifTrue:
		[self declareUndeclaredTemps: methodNode.
		 self removeUnusedTemps: methodNode].
	^methodNode
]

{ #category : #'as yet unclassified' }
SBParser >> statements: argNodes innerBlock: inner blockNode: theBlockNode [

	| ret |
	ret := super statements: argNodes innerBlock: inner blockNode: theBlockNode.
	self addComment.
	^ ret
]
