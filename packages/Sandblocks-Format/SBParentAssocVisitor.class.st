Class {
	#name : #SBParentAssocVisitor,
	#superclass : #ParseNodeVisitor,
	#instVars : [
		'parents'
	],
	#category : 'Sandblocks-Format'
}

{ #category : #'as yet unclassified' }
SBParentAssocVisitor class >> getParentsFrom: aMethodNode [

	| visitor |
	visitor := self new.
	aMethodNode accept: visitor.
	^ visitor parents
]

{ #category : #'as yet unclassified' }
SBParentAssocVisitor >> initialize [

	super initialize.
	
	parents := Dictionary new
]

{ #category : #'as yet unclassified' }
SBParentAssocVisitor >> parents [

	^ parents
]

{ #category : #'as yet unclassified' }
SBParentAssocVisitor >> visitAssignmentNode: aNode [

	parents at: aNode value put: aNode.
	parents at: aNode variable put: aNode.
	super visitAssignmentNode: aNode
]

{ #category : #'as yet unclassified' }
SBParentAssocVisitor >> visitBlockNode: aNode [

	aNode statements do: [:stmt | parents at: stmt put: aNode].
	super visitBlockNode: aNode
]

{ #category : #'as yet unclassified' }
SBParentAssocVisitor >> visitBraceNode: aNode [

	aNode elements do: [:el | parents at: el put: aNode].
	super visitBraceNode: aNode
]

{ #category : #'as yet unclassified' }
SBParentAssocVisitor >> visitCascadeNode: aNode [

	parents at: aNode receiver put: aNode.
	aNode messages do: [:el | parents at: el put: aNode].
	super visitCascadeNode: aNode
]

{ #category : #'as yet unclassified' }
SBParentAssocVisitor >> visitFutureNode: aNode [

	parents at: aNode receiver put: aNode.
	super visitFutureNode: aNode
]

{ #category : #'as yet unclassified' }
SBParentAssocVisitor >> visitMessageNode: aNode [

	parents at: aNode originalReceiver put: aNode.
	aNode originalArguments do: [:arg | parents at: arg put: aNode].
	
	aNode originalReceiver accept: self.
	aNode originalArguments do: [:argument| argument accept: self]
]

{ #category : #'as yet unclassified' }
SBParentAssocVisitor >> visitMessageNodeInCascade: aNode [

	aNode arguments do: [:arg | parents at: arg put: aNode].
	
	super visitMessageNodeInCascade: aNode
]

{ #category : #'as yet unclassified' }
SBParentAssocVisitor >> visitMethodNode: aNode [ 
	parents at: aNode body put: aNode.
	super visitMethodNode: aNode
]

{ #category : #'as yet unclassified' }
SBParentAssocVisitor >> visitReturnNode: aNode [

	parents at: aNode expr put: aNode.
	super visitReturnNode: aNode
]

{ #category : #'as yet unclassified' }
SBParentAssocVisitor >> visitTrackedAssignmentNode: aNode [

	parents at: aNode value put: aNode.
	parents at: aNode variable put: aNode.
	super visitTrackedAssignmentNode: aNode
]
