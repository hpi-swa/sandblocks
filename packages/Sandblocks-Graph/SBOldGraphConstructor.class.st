Class {
	#name : #SBOldGraphConstructor,
	#superclass : #ParseNodeVisitor,
	#instVars : [
		'graph'
	],
	#category : 'Sandblocks-Graph'
}

{ #category : #'as yet unclassified' }
SBOldGraphConstructor >> connect: aSocket to: anotherSocket [

	^ self newConnection connectFrom: aSocket to: anotherSocket
]

{ #category : #'as yet unclassified' }
SBOldGraphConstructor >> graph [

	^ graph
]

{ #category : #'as yet unclassified' }
SBOldGraphConstructor >> initialize [

	super initialize.
	
	graph := PasteUpMorph new
		color: (Color r: 0.502 g: 0.502 b: 0.506);
		extent: 400 @ 200
]

{ #category : #'as yet unclassified' }
SBOldGraphConstructor >> links [

	^ self submorphs select: #isLink
]

{ #category : #'as yet unclassified' }
SBOldGraphConstructor >> newConnection [

	| c |
	c := SBConnector new.
	graph addMorphBack: c.
	^ c
]

{ #category : #'as yet unclassified' }
SBOldGraphConstructor >> newNode [

	| node |
	node := SBNode new.
	graph addMorphBack: node.
	^ node
]

{ #category : #'as yet unclassified' }
SBOldGraphConstructor >> nodes [

	^ self submorphs select: #isNode
]

{ #category : #'as yet unclassified' }
SBOldGraphConstructor >> reposition [

	| root |
	root := self nodes findFirst: [:morph | morph ]
]

{ #category : #'as yet unclassified' }
SBOldGraphConstructor >> visitBlockNode: aNode [

	| node current |
	node := self newNode.
	
	node addOutput: '['.
	node hasFlowOut: true.
	
	current := node.
	aNode statements do: [:stmt | | next |
		next := stmt accept: self.
		next hasFlowOut: true; hasFlowIn: true.
		self connect: current flowOut to: next flowIn.
		current := next].
	
	^ node
]

{ #category : #'as yet unclassified' }
SBOldGraphConstructor >> visitLiteralNode: aNode [

	^ self newNode addOutput: aNode key; yourself
]

{ #category : #'as yet unclassified' }
SBOldGraphConstructor >> visitLiteralVariableNode: aNode [

	^ self newNode addOutput: aNode name; yourself
]

{ #category : #'as yet unclassified' }
SBOldGraphConstructor >> visitMessageNode: aNode [

	| arguments node receiver |
	receiver := aNode receiver accept: self.
	arguments := aNode arguments collect: [:arg | arg accept: self].
	
	node := self newNode.
	self connect: receiver output to: (node addInput: (arguments ifEmpty: [aNode selector key] ifNotEmpty: ['self'])).
	
	arguments ifNotEmpty: [
		aNode selector key keywords with: arguments do: [:part :arg |
			self connect: arg output to: (node addInput: part)]].
	
	node addOutput: ''.
	
	^ node
]

{ #category : #'as yet unclassified' }
SBOldGraphConstructor >> visitReturnNode: aNode [

	| node |
	node := self newNode.
	self connect: (aNode expr accept: self) output to: (node addInput: '^').
	^ node
]

{ #category : #'as yet unclassified' }
SBOldGraphConstructor >> visitVariableNode: aNode [

	^ self visitLiteralVariableNode: aNode
]
