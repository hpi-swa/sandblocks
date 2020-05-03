"
I am an abstract superclass for ParseNode visitors that functions as a null visitor.  Here's the code that defines my interface:

(SystemNavigation default allImplementorsOf: #accept: localTo: ParseNode) do:
	[:methodReference|
	methodReference compiledMethod messages do:
		[:sel|
		((sel beginsWith: 'visit')
		and: [sel numArgs = 1]) ifTrue:
			[ParseNodeVisitor
				compile: (String streamContents:
							[:str|
							str nextPutAll: sel;
								space;
								nextPut: $a.
							methodReference classSymbol first isVowel ifTrue:
								[str nextPut: $n].
							str nextPutAll: methodReference classSymbol])
				classified: 'visiting']]]
"
Class {
	#name : #SBPrecedenceVisitor,
	#superclass : #Object,
	#category : 'Sandblocks-Format'
}

{ #category : #visiting }
SBPrecedenceVisitor >> visitAssignmentNode: anAssignmentNode [

	^ 5
]

{ #category : #visiting }
SBPrecedenceVisitor >> visitBlockNode: aBlockNode [

	^ 0
]

{ #category : #visiting }
SBPrecedenceVisitor >> visitBraceNode: aBraceNode [

	^ 0
]

{ #category : #visiting }
SBPrecedenceVisitor >> visitCascadeNode: aCascadeNode [

	^ 4
]

{ #category : #visiting }
SBPrecedenceVisitor >> visitCommentNode: aCommentNode [

	^ 0
]

{ #category : #visiting }
SBPrecedenceVisitor >> visitFieldNode: aFieldNode [

	^ 0
]

{ #category : #visiting }
SBPrecedenceVisitor >> visitFutureNode: aFutureNode [

	^ 1
]

{ #category : #visiting }
SBPrecedenceVisitor >> visitInstanceVariableNode: anInstanceVariableNode [

	^ 0
]

{ #category : #visiting }
SBPrecedenceVisitor >> visitLiteralNode: aLiteralNode [

	^ 0
]

{ #category : #visiting }
SBPrecedenceVisitor >> visitLiteralVariableNode: aLiteralVariableNode [

	^ 0
]

{ #category : #visiting }
SBPrecedenceVisitor >> visitMessageNode: aMessageNode [

	^ aMessageNode originalSelector precedence
]

{ #category : #visiting }
SBPrecedenceVisitor >> visitMessageNodeInCascade: aMessageNode [

	^ 0
]

{ #category : #visiting }
SBPrecedenceVisitor >> visitMethodNode: aMethodNode [

	^ 0
]

{ #category : #visiting }
SBPrecedenceVisitor >> visitNewArrayNode: aNewArrayNode [

	^ 0
]

{ #category : #visiting }
SBPrecedenceVisitor >> visitRemoteTempVectorNode: aRemoteTempVectorNode [

	^ 0
]

{ #category : #visiting }
SBPrecedenceVisitor >> visitReturnNode: aReturnNode [

	^ 6
]

{ #category : #visiting }
SBPrecedenceVisitor >> visitSelectorNode: aSelectorNode [

	^ 0
]

{ #category : #visiting }
SBPrecedenceVisitor >> visitTempVariableNode: aTempVariableNode [

	^ 0
]

{ #category : #visiting }
SBPrecedenceVisitor >> visitTrackedAssignmentNode: anAssignmentNode [

	^ self visitAssignmentNode: anAssignmentNode
]

{ #category : #visiting }
SBPrecedenceVisitor >> visitUndeclaredVariableNode: aVariableNode [

	^ 0
]

{ #category : #visiting }
SBPrecedenceVisitor >> visitVariableNode: aVariableNode [

	^ 0
]
