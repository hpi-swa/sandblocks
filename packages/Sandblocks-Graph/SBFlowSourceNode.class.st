Class {
	#name : #SBFlowSourceNode,
	#superclass : #SBNewNode,
	#category : 'Sandblocks-Graph'
}

{ #category : #'as yet unclassified' }
SBFlowSourceNode >> autoPlace [

	self autoPlaceFlow
]

{ #category : #'as yet unclassified' }
SBFlowSourceNode >> autoPlaceFlow [

	| current y x |
	y := self top.
	x := self left.
	current := self.
	[current] whileNotNil: [
		current center: x @ y; fullBounds.
		current autoPlaceInputs.
		y := y + current height + 30.
		current := current flowOutSocket connectedLink ifNotNil: #targetNode]
]

{ #category : #'as yet unclassified' }
SBFlowSourceNode >> hasFlowIn [

	^ false
]

{ #category : #'as yet unclassified' }
SBFlowSourceNode >> hasFlowOut [

	^ true
]

{ #category : #'as yet unclassified' }
SBFlowSourceNode >> outputs [

	^ #('[]')
]
