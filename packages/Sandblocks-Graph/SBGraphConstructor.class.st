Class {
	#name : #SBGraphConstructor,
	#superclass : #ParseNodeVisitor,
	#instVars : [
		'graph'
	],
	#category : 'Sandblocks-Graph'
}

{ #category : #'as yet unclassified' }
SBGraphConstructor >> connect: aSocket to: anotherSocket [

	^ self newConnection connectFrom: aSocket to: anotherSocket
]

{ #category : #'as yet unclassified' }
SBGraphConstructor >> graph [

	^ graph
]

{ #category : #'as yet unclassified' }
SBGraphConstructor >> initialize [

	super initialize.
	
	graph := SBGraph new
		color: (Color r: 0.502 g: 0.502 b: 0.506)
]

{ #category : #'as yet unclassified' }
SBGraphConstructor >> newConnection [

	| c |
	c := SBConnector new.
	graph addMorphBack: c.
	^ c
]

{ #category : #'as yet unclassified' }
SBGraphConstructor >> newNode: aClass [

	| node |
	node := aClass new.
	graph addMorphBack: node.
	^ node
]

{ #category : #'as yet unclassified' }
SBGraphConstructor >> visitAssignmentNode: aNode [

	| value variable assignment |
	variable := self visitLiteralNode: aNode variable.
	value := aNode value accept: self.
	
	assignment := self newNode: SBAssignmentNode.
	assignment update.
	self connect: variable outputSockets first to: assignment inputSockets first.
	self connect: value outputSockets first to: assignment inputSockets second.
	
	^ assignment
]

{ #category : #'as yet unclassified' }
SBGraphConstructor >> visitBlockNode: aNode [

	| node current |
	node := self newNode: SBFlowSourceNode.
	
	current := node.
	aNode statements do: [:stmt | | next |
		next := stmt accept: self.
		self connect: current flowOutSocket to: next flowInSocket.
		current := next].
	
	^ node
]

{ #category : #'as yet unclassified' }
SBGraphConstructor >> visitBraceNode: aNode [

	| node current |
	node := self newNode: SBArraySourceNode.
	
	current := node.
	aNode elements do: [:stmt | | next |
		next := stmt accept: self.
		self connect: current flowOutSocket to: next flowInSocket.
		current := next].
	
	^ node
]

{ #category : #'as yet unclassified' }
SBGraphConstructor >> visitCascadeNode: aNode [

	| messages receiver |
	receiver := aNode receiver accept: self.
	messages := aNode messages collect: [:node | (node accept: self) inCascade: true].
	
	messages overlappingPairsDo: [:source :target |
		self connect: source flowOutSocket to: target flowInSocket].
	
	^ messages last
]

{ #category : #'as yet unclassified' }
SBGraphConstructor >> visitLiteralNode: aNode [

	^ (self newNode: SBLiteralNode) name: aNode key asString; yourself
]

{ #category : #'as yet unclassified' }
SBGraphConstructor >> visitLiteralVariableNode: aNode [

	^ (self newNode: SBLiteralNode) name: aNode name; yourself
]

{ #category : #'as yet unclassified' }
SBGraphConstructor >> visitMessageNode: aNode [

	| arguments node receiver |
	receiver := aNode originalReceiver accept: self.
	arguments := aNode originalArguments collect: [:arg | arg accept: self].
	
	node := self newNode: SBMessageNode.
	node selector: aNode originalSelector.
	self connect: receiver outputSockets first to: node inputSockets first.
	
	arguments ifNotEmpty: [
		node inputSockets allButFirst with: arguments do: [:input :arg |
			self connect: arg outputSockets first to: input]].
	
	^ node
]

{ #category : #'as yet unclassified' }
SBGraphConstructor >> visitReturnNode: aNode [

	| node |
	node := self newNode: SBReturnNode.
	self connect: (aNode expr accept: self) outputSockets first to: (node inputSockets first).
	^ node
]

{ #category : #'as yet unclassified' }
SBGraphConstructor >> visitTempVariableNode: aNode [

	^ self visitLiteralNode: aNode
]

{ #category : #'as yet unclassified' }
SBGraphConstructor >> visitTrackedAssignmentNode: aNode [

	^ self visitAssignmentNode: aNode
]

{ #category : #'as yet unclassified' }
SBGraphConstructor >> visitVariableNode: aNode [

	^ self visitLiteralVariableNode: aNode
]
